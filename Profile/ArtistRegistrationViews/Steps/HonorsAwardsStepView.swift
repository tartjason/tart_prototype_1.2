import SwiftUI

struct HonorsAwardsStepView: View {
    @EnvironmentObject var viewModel: ArtistRegistrationViewModel
    @State private var showingAddHonorAward = false
    
    var body: some View {
        StepContainerView(
            title: "Honors and Awards",
            addButtonText: "Add",
            onAddTapped: { showingAddHonorAward = true }
        ) {
            ForEach(viewModel.artistProfile.honorsAndAwards) { honor in
                ItemCardView(
                    title: honor.prizeName,
                    subtitle: honor.year
                )
            }
        }
        .sheet(isPresented: $showingAddHonorAward) {
            AddHonorAwardView()
                .environmentObject(viewModel)
        }
    }
}
