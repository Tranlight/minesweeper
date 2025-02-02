### Overview
Web Application that generates a minesweeper board using Ruby on Rails

### Deploy to heroku
<a href="https://www.heroku.com/deploy?template=https://github.com/Tranlight/minesweeper">
  <img src="https://www.herokucdn.com/deploy/button.svg" alt="Deploy">
</a> 

### Requirement Analysis
**Primary Functionalities:**
1. **User Input and Board Generation**:
  - A homepage to input user details (email, board dimensions, number of mines, and board name).
  - "Generate Board" button triggers:
    - Server-side board generation algorithm.
    - Saving the generated board in the database.
    - Redirecting to a page displaying the board details and its visual representation.

2. **Board Display**:
  - Show a generated board visually (2D grid with symbols for empty cells and mines).
  - Display board metadata (name, email, and creation time).

3. **Recent Boards List**:
  - Display the 10 most recently generated boards on the homepage.
  - Include metadata and links to individual board pages.
  - Provide a "View All Generated Boards" link.

4. **Algorithm**:
  - A performant Minesweeper board generator that works for any board size and mine count.
  - The algorithm must return a 2D array representing the board's initial state.

**Optional Enhancements:**
  - Pagination for the boards list.
- Search and filtering by board name, email, or creation date.
- Improved UI/UX using features like live board previews or interactive grid inputs.

### Execution Plan

#### **1. Setup and Environment Configuration**
- Initialize a new Rails app.
- Set up Heroku for deployment.
- Configure the Mysql database.
- Add necessary gems:
  - **`bootstrap`** for CSS styling.
  - **`mysql`** for Mysql.
  - **`kaminari`** for pagination (optional feature).

#### **2. Database Design**
- **Board Model**:
  - **Attributes**:
    - `name`: string
    - `email`: string
    - `width`: integer
    - `height`: integer
    - `total_mines`: integer
  - **Timestamps**.

#### **3. Minesweeper Board Generation Algorithm**
- **Input:** `width`, `height`, and `total_mines`.  
- **Steps:**  
  1. Divide the board into smaller blocks.  
  2. Randomly place mines in blocks overlapping the current view.  
- **Output:** A 2D array of objects representing cell states within the view.  

#### **4. Application Features**
- **Homepage**:
  - Form for board input.
  - Recent boards list.

- **Controller Actions**:
  - `new`: Render form for board generation.
  - `create`: Handle board creation and save to database.
  - `show`: Display a specific board.

- **Views**:
  - Use Bootstrap for styling.
  - Represent the board visually with a grid layout (`table` or `div` elements).

- **Navigation**:
  - Links to individual board pages.
  - "View All Generated Boards" with a paginated list.

#### **5. Testing**
- Test the Minesweeper generation algorithm with various board sizes and mine counts.
- Validate forms for proper inputs (e.g., ensure `total_mines` doesn’t exceed the total number of cells).
- Write feature tests for the user flow and board visualization.

#### **6. Deployment**
- Push the code to GitHub.
- Deploy to Heroku.
- Verify the app is accessible via a public Heroku link.

### Milestones

| Task                             | Estimated Time | Notes                                      |
| -------------------------------- | -------------- | ------------------------------------------ |
| Initialize Rails project         | 3 hours        | Includes gem setup and environment config. |
| Design Database and Models       | 2 hours        | Design and implement Board model.          |
| Board Generation Algorithm       | 8 hours        | Optimize for performance.                  |
| Homepage and Board Creation Form | 3 hours        | Use Bootstrap for styling.                 |
| Board Visualization              | 8 hours        | Display boards as a grid.                  |
| Recent Boards and Navigation     | 2 hours        | Include links and pagination if needed.    |
| Testing                          | 3 hours        | Algorithm and feature tests.               |
| Deployment                       | 2 hours        | Push to GitHub and deploy on Heroku.       |

### Deliverables
1. **Public GitHub Repo**:
  - Includes clear README with setup and usage instructions.
  - Document Minesweeper algorithm and assumptions.

2. **Heroku App Link**:
  - Functional, accessible, and tested.
