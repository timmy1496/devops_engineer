use gymDatabase

db.workouts.find(
    { difficulty: "medium" },
    { _id: 0 }
)
