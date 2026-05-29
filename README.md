# VetClinic - Lab 9 (Authorization with Pundit)

## Description
This repository contains the implementation for Laboratory 9

## Setup and Installation
To get the application up and running, follow these steps:

1. **Install dependencies:**
   ```
   bundle install
   yarn install
   ```

2. **Database setup:**
   To test the application, please run the following command to reset and seed the database:
   ```
   bin/rails db:drop db:create db:migrate db:seed
   ```
   This will generate three default users (one for each system role). You can log in using any of the following credentials:

   | Role  | Name                | Email                 | Password    |
   | :---  | :---                | :---                  | :---        |
   | Admin | Admin System        | admin@vet.com         | password123 |
   | Vet   | Juan Perez          | jupe@vet.com          | password123 |
   | Vet   | Felipe De la Noi    | fede@vet.com          | password123 |
   | Owner | Matias Recabarren   | matre@example.com     | password123 |
   | Owner | Max Garcia          | magar@example.com     | password123 |
   | Owner | Andres Howard       | anhow@example.com     | password123 |

3. **Run the application:**
   Since this project uses `esbuild`, you must use `bin/dev` to compile JavaScript and CSS assets alongside the server.
   ```
   bin/dev
   ```

## Notes for the Reviewer

## Notes for the Reviewer

* The system enforces a strict hierarchical role matrix divided among Administrators, Veterinarians, and Pet Owners to ensure data security and functional isolation. Administrators hold unrestricted global access, allowing them full CRUD (Create, Read, Update, Delete) capabilities over all system entities, including managing clinic staff, modifying system-wide statuses, and overriding appointment schedules. Veterinarians operate with visibility into the clinic's general patient registry but are strictly constrained to data within their own medical scope; they can only schedule, view, and update appointments assigned to themselves, and they possess exclusive rights to author or modify rich-text treatments for those specific clinical sessions. Meanwhile, Pet Owners are bound to a strict multi-tenant privacy silo where they can only view or update their personal profile details and access the historical appointments, scheduling logs, and treatment notes directly associated with their own registered pets, ensuring complete confidentiality between different clients.
* **Conditional UI Elements:** Views across the application conditionally render buttons like "New", "Edit", and "Delete" using `<% if policy(record).action? %>` blocks. If a user lacks the authorization to perform a specific action, the user interface gracefully hides the corresponding interactive components.
* **Pre-assignment Context Fix:** To avoid the common authorization failure known as "The Empty Object Trap" during new record initiation, both `AppointmentsController` and `TreatmentsController` pre-populate empty model instances with the authenticated context (e.g., `@appointment.vet = current_user.vet`) before executing the `authorize` helper within `#new` and `#create`.
* **Pundit Policy Scopes:** The `policy_scope` helper is uniformly applied to index actions. This ensures that records are structurally filtered at the database query level; for instance, navigating to the appointments list as an Owner strictly queries and returns data pertaining to that owner's specific pets.
* **Permitted Attributes Delegation:** Parameter safety is delegated dynamically to Pundit in controller updates via `permitted_attributes(@appointment)`. This allows role-specific parameter filtering (e.g., an Admin can alter the appointment's assigning `vet_id` or global `status`, while a Veterinarian's updates are restricted purely to consultation details).
* **ActionText Rich Text Notes:** Treatments incorporate `clinical_notes` managed via Rails ActionText (Trix Editor). Strong parameter parsing in `TreatmentsController` has been updated to seamlessly capture the rich text container safely alongside regular standard scalar fields.
* **Devise Hook Protection:** System-wide fallback checks (`verify_authorized` and `verify_policy_scoped`) are applied globally to ensure strict policy usage. To avoid interference with Devise controllers, explicit dynamic skip-evaluations were added to `ApplicationController` to filter out Devise requests.

## System Dependencies
This application relies on **libvips** for Active Storage image processing (variants, resizing, and analysis). Please ensure it is installed on your system:

- **macOS (Homebrew):** `brew install vips`
- **Ubuntu/Debian:** `sudo apt install libvips`
- **Arch Linux:** `sudo pacman -S libvips`

