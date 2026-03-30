use gymDatabase

db.clients.insertMany([
    { client_id: 1, name: "Ivan Petrenko", age: 32, email: "ivan.petrenko@example.com" },
    { client_id: 2, name: "Maria Kovalenko", age: 27, email: "maria.kovalenko@example.com" },
    { client_id: 3, name: "Oleh Shevchenko", age: 41, email: "oleh.shevchenko@example.com" }
])

db.memberships.insertMany([
    {
        membership_id: 101,
        client_id: 1,
        start_date: ISODate("2025-01-01"),
        end_date: ISODate("2025-06-30"),
        type: "premium"
    },
    {
        membership_id: 102,
        client_id: 2,
        start_date: ISODate("2025-02-15"),
        end_date: ISODate("2025-05-15"),
        type: "standard"
    },
    {
        membership_id: 103,
        client_id: 3,
        start_date: ISODate("2025-03-01"),
        end_date: ISODate("2025-09-01"),
        type: "vip"
    }
])

db.workouts.insertMany([
    { workout_id: 201, description: "Upper body strength", difficulty: "medium" },
    { workout_id: 202, description: "Cardio 30 minutes", difficulty: "easy" },
    { workout_id: 203, description: "Leg day intensive", difficulty: "hard" },
    { workout_id: 204, description: "Core & mobility", difficulty: "medium" }
])

db.trainers.insertMany([
    { trainer_id: 301, name: "Olena Bondar", specialization: "strength training" },
    { trainer_id: 302, name: "Serhii Kozak", specialization: "functional training" },
    { trainer_id: 303, name: "Anna Lysenko", specialization: "yoga" }
])

