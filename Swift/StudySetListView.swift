import SwiftUI
import SwiftData

struct StudySetListView: View {
    @Query var sets: [StudySet]

    var body: some View {
        NavigationView {
            List(sets) { set in
                NavigationLink(destination: LearnModeView(set: set)) {
                    VStack(alignment: .leading) {
                        Text(set.title)
                            .font(.headline)
                        Text(set.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Study Sets")
        }
    }
}

#Preview {
    // Preview with sample data
    let previewSets = [
        StudySet(title: "Biology", description: "Cell structure"),
        StudySet(title: "Chemistry", description: "Periodic table")
    ]
    let modelContainer = try! ModelContainer(for: StudySet.self, Term.self, configurations: [.init(isStoredInMemoryOnly: true)])
    previewSets.forEach { modelContainer.mainContext.insert($0) }

    return StudySetListView()
        .modelContainer(modelContainer)
}
