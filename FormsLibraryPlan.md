# Forms Library Integration Plan

## Goals
- Add a dedicated **Forms** tab in the bottom tab bar that opens a global Forms Library (not job-scoped).
- Create and edit form templates in the library; forms are **not** created inside Jobs.
- Jobs attach forms from existing templates only.
- Job form instances should receive updates if their source template changes.
- Captures occur within a form while completing it and can also be uploaded directly into the job's media library (section-level capture entry points in forms).

## Proposed Architecture
- **Form Templates**: Introduce new SwiftData models for reusable templates (e.g., `FormTemplate`, `FormTemplateSection`, `FormTemplateField`). Templates live independently of jobs.
- **Job Form Instances**: Maintain separate models for job-specific instances (e.g., `JobFormInstance`, `JobFormSectionInstance`, `JobFormFieldInstance`). Instances reference their originating template ID/version for updates.
- **Versioning & Updates**: Track template version and last modified timestamp. When templates change, update linked job instances according to defined rules (see Migration section) so jobs receive template updates.
- **Navigation**: Update `RootTabView` (or equivalent) to include a Forms tab that presents a library list view. The library supports create/edit/delete of templates and drill-down into sections/fields.
- **Capture Access**: Within job form completion, capture options appear at section level; the job's media library view also allows direct uploads.

## UX Flows
- **Library Management**: Users open Forms tab → see list of templates → create/edit template (sections, fields, capture settings) → save template.
- **Attach to Job**: From a job, choose "Add Form" → picker shows templates → selecting a template creates a job form instance cloned from the template.
- **Complete Form**: Within a job form, users fill fields and capture media at section level; media is stored with the job and surfaced in its media library.

## Data Model Tasks
- Add SwiftData models for template entities with relationships to sections/fields and optional capture metadata.
- Add migration logic linking job form instances to template IDs/versions for update propagation.
- Ensure job form instances store media references scoped to the job while preserving linkage back to sections/fields.

## Navigation & UI Tasks
- Insert a Forms tab in the bottom tab bar that routes to the Forms Library list view.
- Build Forms Library screens for browsing templates and editing template details (sections/fields), reusing existing form rendering components where possible.
- Update job form creation flow to pull exclusively from templates; remove job-level form creation.
- Provide section-level capture entry points during job form completion; add upload entry point in job media library view.

## Synchronization & Updates
- Define behavior when templates change:
  - If a template is updated, propagate changes to all job form instances referencing it (e.g., add new fields, update labels). Preserve job-specific field responses where applicable.
  - Maintain template versioning to aid debugging and potential rollback.

## Migration Considerations
- For existing jobs/forms, map current job form instances to new template model (possibly create a template per existing form definition and associate jobs accordingly).
- Prepare to import external `.docx` draft forms into the Forms Library once the UI and models are ready.

## Open Items for Confirmation
- Preferred update strategy when a template change conflicts with job-captured data (e.g., deleted fields): archive old data or move to notes?
- Any validation rules or publication workflow needed before a template can be used on jobs?

## Next Steps
1. Implement template SwiftData models and relationships.
2. Add Forms tab and initial library list UI.
3. Build template create/edit screens (sections, fields, capture settings).
4. Update job form creation to select from templates and link instances for update propagation.
5. Add section-level capture controls in form completion and upload entry in job media library.
6. Design migration for existing job forms and external `.docx` drafts into templates.
