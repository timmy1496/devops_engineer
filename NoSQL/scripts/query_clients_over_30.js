use gymDatabase

db.clients.find(
    { age: { $gt: 30 } },
    { _id: 0 }
)
