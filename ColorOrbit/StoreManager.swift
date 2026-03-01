//
//  StoreManager.swift
//  ColorOrbit
//

import StoreKit

@MainActor
class StoreManager: ObservableObject {

    static let productIDs = ["co_undo_15", "co_undo_50", "co_undo_200"]

    @Published var products: [Product] = []
    @Published var isPurchasing: Bool = false

    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    // MARK: - Purchase

    func purchase(_ product: Product, gameManager: GameManager) async {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                let undoCount = undosForProduct(transaction.productID)
                gameManager.addUndos(undoCount)
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    // MARK: - Restore (consumables don't restore, but included for completeness)

    func restorePurchases() async {
        try? await AppStore.sync()
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if let transaction = try? await self.checkVerified(result) {
                    await transaction.finish()
                }
            }
        }
    }

    // MARK: - Helpers

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let value):
            return value
        }
    }

    private func undosForProduct(_ productID: String) -> Int {
        switch productID {
        case "co_undo_15":  return 15
        case "co_undo_50":  return 50
        case "co_undo_200": return 200
        default:            return 0
        }
    }
}
