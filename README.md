# UCC Classroom Availability Finder (C++ backend + HTML front end)

A web page (HTML/CSS/JavaScript) that shows classrooms. The classroom data is stored and processed by a **C++ program** using a plain array.

## How it fits together

```
Browser (frontend/)  --- HTTP requests --->  C++ server (backend/)
  index.html, CSS, JS   <--- JSON answers ---  Classroom rooms[MAX_ROOMS]  (the array)
                                                    |
                                              data/classrooms.txt  (saved between runs)
```

- `backend/classroom_store.h/.cpp` - the array and every operation on it, written with loops.
- `backend/main.cpp` - a small web server. It turns browser requests into calls on the array and sends the answer back as JSON. It also serves the files in `frontend/`.
- `frontend/` - the user interface. It only displays data; it never searches or sorts.
- `tests/test_store.cpp` - tests for the array logic.

## Where the arrays are used

| Task | How it is done in `classroom_store.cpp` |
|---|---|
| Store all rooms | `Classroom rooms[MAX_ROOMS]` plus a `count` of used slots |
| Search by ID | `findIndexById`: linear search with a `for` loop |
| Add a room | `addRoom`: put it in `rooms[count]`, then `count++` |
| Delete a room | `removeRoom`: shift later rooms one step left, then `count--` |
| Update a room | `updateRoom`: find the index, overwrite that slot |
| Search and filter | `filterRooms`: loop over the array and collect matching positions |
| Sort | `sortIndexes`: insertion sort |
| Totals | `getStats`: one loop adding up counts and seats |
| Unique buildings | `getBuildings`: nested loops, then insertion sort |

## Run it (Windows, MSYS2 UCRT64)

1. Double-click `build-and-run.bat`. It compiles the server and opens http://localhost:8080.
2. Keep the black window open while you use the page. Press Ctrl+C in it to stop.
3. Run the tests with `run-tests.bat`.

Opening `index.html` directly from the folder will not work, because the page needs the C++ server.

## Data

The 12 rooms are fictional sample data (not live university data). On the first run the server creates `data/classrooms.txt` from them. Add, edit and delete in the page are saved there. "Reset sample data" restores the original 12 rooms.

## API (for the presentation)

| Request | What it does |
|---|---|
| `GET /api/classrooms?query=&availability=&building=&groupSize=&sort=` | filtered and sorted list |
| `GET /api/classrooms/ROOM-001` | one room (linear search) |
| `POST /api/classrooms` | add a room |
| `PUT /api/classrooms/ROOM-001` | update a room |
| `DELETE /api/classrooms/ROOM-001` | delete a room |
| `GET /api/summary` | totals and building names |
| `POST /api/reset` | restore sample data |

## Deploying online (Render, using Docker)

The `Dockerfile` compiles the C++ server and runs it together with the `frontend` folder. The server reads the `PORT` setting from the host and listens on all addresses when `PORT` is set.

1. Push this folder to a GitHub repository (the `Dockerfile` must be at the top level).
2. Sign in to render.com with GitHub.
3. Click New > Web Service and choose your repository.
4. Choose **Docker** as the language and the **Free** instance type, then click Create Web Service.
5. Wait for the build to finish. Render gives you a public link ending in `.onrender.com`.

Notes for the demo:
- On a free instance the site goes to sleep when idle, so open the link a minute before presenting.
- A free instance has no permanent disk. If the service restarts, `data/classrooms.txt` is lost and the 12 sample rooms come back.
- There is no login, so anyone with the link can add or delete rooms. This is a demonstration only.

To test the Docker image on your own computer (needs Docker Desktop):
`docker build -t ucc-finder .` then `docker run -p 10000:10000 ucc-finder` and open http://localhost:10000
