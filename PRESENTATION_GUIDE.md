# Presentation Guide: UCC Classroom Availability Finder

## One-minute summary (say this first)

"My project is a classroom finder. The page is built with HTML, CSS and JavaScript. All the data lives in a C++ program, inside one array of 300 slots called `rooms`. When you search, filter, sort, add or delete, the page sends a request to the C++ server. The server does the work with loops on the array and sends the answer back. The array is the heart of the project."

## Quick demo order

1. Start with `build-and-run.bat`. Show the page loading 12 rooms.
2. Type a group size (for example 25). Only available rooms that fit appear.
3. Search "library", then sort by capacity.
4. Add a room, then delete it.
5. Open `classroom_store.cpp` and point to the matching function for each step.

## Likely questions and answers

**1. What is an array?**
A fixed number of items of the same type stored next to each other in memory. Each item has a number called an index, starting at 0.

**2. Where is the array in your project?**
In `backend/classroom_store.h`: `Classroom rooms[MAX_ROOMS];`. Each slot holds one classroom. A second variable, `count`, says how many slots are in use.

**3. Why do you need `count`?**
The array always has 300 slots, but only some hold rooms. `count` marks where the used part ends, so every loop uses `i < count`. This also stops us reading empty slots.

**4. What happens when the array is full?**
`addRoom` refuses and returns the error "The room array is full." This is the main weakness of arrays: the size is fixed when the program is written. A vector would grow, but the assignment is about arrays.

**5. How does searching by ID work?**
`findIndexById` is a linear search. It starts at slot 0 and checks each room's ID until it finds a match. It returns the slot number, or -1 if there is no match.

**6. Why linear search and not binary search?**
Binary search only works on a sorted array. Our rooms are kept in the order they were added, and deleting and adding can change that order. With at most 300 rooms, a linear search is fast enough and simple to explain.

**7. How does adding a room work?**
The new room is copied into `rooms[count]`, the first empty slot, and then `count` goes up by one. It does not need to move anything.

**8. How does deleting a room work?**
After finding the room, every room after it moves one slot to the left, then `count` goes down by one. This closes the gap so there are no empty slots in the middle.

**9. Why does delete take longer than add?**
Add touches one slot. Delete may move many rooms. If you delete the first room, all the others shift.

**10. How does filtering work?**
`filterRooms` loops through all rooms. For each one it checks the search text, availability, building and group size. Matching rooms' slot numbers are written into a second array called `matches`.

**11. Why do you store slot numbers instead of copying rooms?**
A slot number is a small integer, so it is cheap to store and move. Copying a whole room would copy several strings. It also keeps the original array unchanged.

**12. Which sorting method do you use, and why?**
Insertion sort in `sortIndexes`. It takes each item and slides it left until it is in the right place. It is easy to explain, and it is fast enough for 300 rooms. Because it is stable, rooms with equal capacity stay in a sensible order (we also break ties by name).

**13. What are the time complexities?** (n = number of rooms)

| Operation | Time | Why |
|---|---|---|
| Access `rooms[i]` | O(1) | Jump straight to the slot |
| Add | O(1) | One slot written |
| Search by ID | O(n) | May check every slot |
| Delete | O(n) | Search plus shifting |
| Filter | O(n) | One pass through the array |
| Sort | O(n²) worst case | Insertion sort |
| Totals | O(n) | One pass |

**14. What stops the program reading outside the array?**
Every loop stops at `count`, and `addRoom` checks `count >= MAX_ROOMS` before writing. Reading or writing outside an array is a serious bug in C++, because it does not check for you.

**15. Why use C++ for the backend and HTML for the front end?**
They have separate jobs. HTML and JavaScript show things and take input. C++ stores the data and runs the array logic. This is how most real applications are built, and it keeps the array code in one place.

**16. How does the browser talk to C++?**
Through HTTP. The browser sends a request such as `GET /api/classrooms?groupSize=25`. The C++ server runs the array functions and replies with JSON, which is plain text describing the rooms. The page turns it into cards.

**17. Where is the data saved?**
In `data/classrooms.txt`, one room per line. The server loads that file into the array when it starts, and saves it again after every add, edit or delete.

**18. Is this real university data?**
No. The 12 rooms are fictional sample data. Capacity, facilities and availability are for demonstration only and are not live occupancy information.

**19. Could the server handle many users at once?**
Not in this version. It answers one request at a time, which is fine for a demonstration. A real system would need threads or a proper web server and a database.

**20. What would you improve?**
Use a dynamic array or a database so there is no fixed limit. Add a login for admin actions. Connect it to the real timetable so availability is live.

## Where to find each idea in the code

| Idea | File and function |
|---|---|
| The array | `classroom_store.h`: `Classroom rooms[MAX_ROOMS]` |
| Linear search | `classroom_store.cpp`: `findIndexById` |
| Add | `addRoom` |
| Delete (shifting) | `removeRoom` |
| Filter | `filterRooms` |
| Sort | `sortIndexes` |
| Totals | `getStats` |
| Server and JSON | `main.cpp` |
| Tests | `tests/test_store.cpp` |
