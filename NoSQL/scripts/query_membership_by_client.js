use gymDatabase

const CLIENT_ID = 1

db.clients.aggregate([
    { $match: { client_id: CLIENT_ID } },
    {
        $lookup: {
            from: "memberships",
            localField: "client_id",
            foreignField: "client_id",
            as: "membership"
        }
    },
    {
        $project: {
            _id: 0,
            name: 1,
            age: 1,
            email: 1,
            membership: 1
        }
    }
])
