import Testing
import UIKit
@testable import RickAndMortyApp

@Suite("HomeView")
@MainActor
struct HomeViewTests {
    @Test
    func testSetSearchEmptyState_WhenLoadingIsActive_KeepsTableHidden() {
        let sut = HomeView()

        sut.setLoading(true)
        sut.setSearchEmptyState(false)

        #expect(sut.tableView.isHidden)
    }

    @Test
    func testSetLoading_WhenSearchEmptyStateIsVisible_KeepsTableHidden() {
        let sut = HomeView()

        sut.setSearchEmptyState(true)
        sut.setLoading(false)

        #expect(sut.tableView.isHidden)
    }

    @Test
    func testSetLoading_WhenNeitherStateIsActive_ShowsTable() {
        let sut = HomeView()

        sut.setLoading(true)
        sut.setSearchEmptyState(true)
        sut.setLoading(false)
        sut.setSearchEmptyState(false)

        #expect(!sut.tableView.isHidden)
    }
}
