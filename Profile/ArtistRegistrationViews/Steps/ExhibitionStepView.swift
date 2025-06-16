import SwiftUI

struct ExhibitionStepView: View {
    @EnvironmentObject var viewModel: ArtistRegistrationViewModel
    @State private var showingAddExhibition = false
    
    var body: some View {
        StepContainerView(
            title: "Exhibition Experiences",
            addButtonText: "Add",
            onAddTapped: { showingAddExhibition = true }
        ) {
            ForEach(viewModel.artistProfile.exhibitions) { exhibition in
                ItemCardView(
                    title: exhibition.exhibitionName,
                    subtitle: "\(exhibition.location)\n\(exhibition.monthYear)"
                )
            }
        }
        .sheet(isPresented: $showingAddExhibition) {
            AddExhibitionView()
                .environmentObject(viewModel)
        }
    }
}
