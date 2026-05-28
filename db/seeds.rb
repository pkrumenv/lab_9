# Clear existing data
puts "Clearing data database..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Owner.destroy_all
Vet.destroy_all
User.destroy_all

puts "Creating users..."

# Admin
User.create!(
  first_name: "Admin",
  last_name: "System",
  email: "admin@vet.com",
  password: "password123",
  password_confirmation: "password123",
  role: :admin
)

# Owner Users
u_owner1 = User.create!(first_name: "Matias", last_name: "Recabarren", email: "matre@example.com", password: "password123", password_confirmation: "password123", role: :owner)
u_owner2 = User.create!(first_name: "Max", last_name: "Garcia", email: "magar@example.com", password: "password123", password_confirmation: "password123", role: :owner)
u_owner3 = User.create!(first_name: "Andres", last_name: "Howard", email: "anhow@example.com", password: "password123", password_confirmation: "password123", role: :owner)

# Vet Users
u_vet1 = User.create!(first_name: "Juan", last_name: "Perez", email: "jupe@vet.com", password: "password123", password_confirmation: "password123", role: :vet)
u_vet2 = User.create!(first_name: "Felipe", last_name: "De la Noi", email: "fede@vet.com", password: "password123", password_confirmation: "password123", role: :vet)


puts "Creating Owners..."
# Nota cómo ahora pasamos el user asociado a cada owner
owner1 = Owner.create!(user: u_owner1, first_name: "Matias", last_name: "Recabarren", email: "matre@example.com", phone: "123456789", address: "Calle 65")
owner2 = Owner.create!(user: u_owner2, first_name: "Max", last_name: "Garcia", email: "magar@example.com", phone: "987654321", address: "Calle 51")
owner3 = Owner.create!(user: u_owner3, first_name: "Andres", last_name: "Howard", email: "anhow@example.com", phone: "456123789", address: "Calle 70")

puts "Creating Vets..."
# Lo mismo para los veterinarios
vet1 = Vet.create!(user: u_vet1, first_name: "Juan", last_name: "Perez", email: "jupe@vet.com", phone: "111111111", specialization: "General")
vet2 = Vet.create!(user: u_vet2, first_name: "Felipe", last_name: "De la Noi", email: "fede@vet.com", phone: "222222222", specialization: "Surgery")


puts "Creating Pets..."
pet1 = owner1.pets.create!(name: "Advincula", species: "dog", breed: "Pug", date_of_birth: "2020-01-01", weight: 25)
pet2 = owner1.pets.create!(name: "Pelusa", species: "cat", breed: "Black", date_of_birth: "2019-05-10", weight: 5)
pet3 = owner2.pets.create!(name: "Folagor", species: "rabbit", breed: "Mini Lop", date_of_birth: "2021-03-15", weight: 2)
pet4 = owner3.pets.create!(name: "Rene", species: "dog", breed: "Dachshund", date_of_birth: "2018-07-20", weight: 20)
pet5 = owner2.pets.create!(name: "Whatley", species: "cat", breed: "Persian", date_of_birth: "2022-02-02", weight: 4)


pet1.photo.attach(io: File.open(Rails.root.join('db', 'seeds', 'pets', 'pug.webp')), filename: 'pug.webp', content_type: 'image/webp')
pet2.photo.attach(io: File.open(Rails.root.join('db', 'seeds', 'pets', 'gato.webp')), filename: 'gato.webp', content_type: 'image/webp')
pet4.photo.attach(io: File.open(Rails.root.join('db', 'seeds', 'pets', 'salchicha.webp')), filename: 'salchicha.webp', content_type: 'image/webp')


puts "Creating Appointments..."
appt1 = Appointment.create!(pet: pet1, vet: vet1, date: 2.days.from_now, reason: "Checkup", status: :scheduled)
appt2 = Appointment.create!(pet: pet2, vet: vet1, date: 1.week.ago, reason: "Vaccination", status: :in_progress)
appt3 = Appointment.create!(pet: pet3, vet: vet2, date: 3.days.ago, reason: "Injury", status: :completed)
appt4 = Appointment.create!(pet: pet4, vet: vet2, date: 1.month.from_now, reason: "Surgery", status: :cancelled)
appt5 = Appointment.create!(pet: pet5, vet: vet1, date: 2.weeks.ago, reason: "Dermatitis", status: :completed)


puts "Creating Treatments..."

Treatment.create!(
  appointment: appt2, 
  name: "Annual Rabies Vaccination", 
  medication: "Rabvac 3", 
  dosage: "1 mL", 
  administered_at: 1.week.ago,
  clinical_notes: %Q(
    <h2>Vaccination Record</h2>
    <p>The annual rabies booster was administered. The patient <strong>did not show</strong> any immediate adverse reactions to the injection.</p>
    <ul>
      <li>Vital signs: Stable</li>
      <li>Body Temperature: 38.5°C</li>
    </ul>
    <p>Owner advised to monitor for lethargy over the next 24 hours.</p>
  )
)

Treatment.create!(
  appointment_id: appt2.id,
  name: "General Checkup & Deworming",
  medication: "Broad-spectrum Dewormer",
  dosage: "1 tablet",
  administered_at: 1.week.ago,
  clinical_notes: %Q(
    <h1>Annual Checkup: Pelusa</h1>
    <p>The feline patient is in <strong>good general condition</strong> and appears very energetic.</p>
    <ul>
      <li>Current weight: 5kg</li>
      <li>Vaccination schedule: Up to date</li>
      <li>Coat: Shiny and free of ectoparasites</li>
    </ul>
    <p><em>Extra note:</em> Oral dewormer was successfully administered hidden in wet food.</p>
  )
)

Treatment.create!(
  appointment: appt3, 
  name: "Wound Care and Dressing", 
  medication: "Sterile Saline & Betadine", 
  dosage: "Cleanse 2x daily", 
  administered_at: 3.days.ago,
  clinical_notes: %Q(
    <h1>Injury Treatment: Folagor</h1>
    <p>The rabbit presented a superficial laceration on the right hind leg, likely due to a cage accident.</p>
    <ol>
      <li>Deep cleaning with physiological saline.</li>
      <li>Applied povidone-iodine solution.</li>
      <li>Applied light bandage to prevent licking/biting.</li>
    </ol>
    <p><strong>Strict rest</strong> is recommended for at least 3 days to ensure proper healing.</p>
  )
)

Treatment.create!(
  appointment: appt3, 
  name: "Pain Management", 
  medication: "Meloxicam", 
  dosage: "0.2 mg/kg", 
  administered_at: 3.days.ago,
  clinical_notes: %Q(
    <h2>Analgesic Control</h2>
    <p>Prescribed for wound pain management. Administer only if the patient shows signs of severe discomfort (e.g., teeth grinding or constant hunched posture).</p>
  )
)

Treatment.create!(
  appointment: appt5, 
  name: "Dermatological Treatment", 
  medication: "Corticosteroid Ointment", 
  dosage: "Apply thin layer daily", 
  administered_at: 2.weeks.ago,
  clinical_notes: %Q(
    <h1>Dermatology Evaluation: Whatley</h1>
    <p>Observed areas of alopecia and severe redness in the abdominal region.</p>
    <ul>
      <li><strong>Presumptive Diagnosis:</strong> Severe atopic dermatitis.</li>
      <li><strong>Prognosis:</strong> Guarded. If the treatment is not followed daily, secondary infections could become systemic.</li>
    </ul>
    <p>Use of an <strong>Elizabethan collar is mandatory</strong> 24/7 during the first week.</p>
  )
)

puts "Seed data created successfully!"