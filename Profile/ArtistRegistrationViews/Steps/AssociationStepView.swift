import SwiftUI

struct AssociationStepView: View {
    @EnvironmentObject var viewModel: ArtistRegistrationViewModel
    @State private var showingAddAssociation = false
    
    var body: some View {
        StepContainerView(
            title: "Affiliation/Association",
            addButtonText: "Add association",
            onAddTapped: { showingAddAssociation = true }
        ) {
            ForEach(viewModel.artistProfile.associations) { association in
                ItemCardView(
                    title: association.institutionName,
                    subtitle: "\(association.city), \(association.country)"
                )
            }
        }
        .sheet(isPresented: $showingAddAssociation) {
            AddAssociationView()
                .environmentObject(viewModel)
        }
    }
}

