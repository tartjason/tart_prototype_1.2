import SwiftUI

struct EducationStepView: View {
    @EnvironmentObject var viewModel: ArtistRegistrationViewModel
    @State private var showingAddEducation = false
    
    var body: some View {
        StepContainerView(
            title: "Experience and background",
            addButtonText: "Add education",
            onAddTapped: { showingAddEducation = true }
        ) {
            ForEach(viewModel.artistProfile.education) { education in
                ItemCardView(
                    title: education.institution,
                    subtitle: "\(education.graduationYear)\n\(education.major)"
                )
            }
        }
        .sheet(isPresented: $showingAddEducation) {
            AddEducationView()
                .environmentObject(viewModel)
        }
    }
}
