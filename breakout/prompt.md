> You are a senior software engineer. Implement the classic **Breakout** game (arkanoid) in a **single HTML file** that opens directly in the browser with no server, no external dependencies, and no internet connection.
>
> **Functional requirements:**
> 1. Fixed 2D canvas (800×600). Render the paddle, the ball, and a grid of bricks (8 columns × 5 rows).
> 2. The ball bounces off the walls (left/right/top), the paddle, and destroys bricks on collision. Bricks in different rows must have different colors.
> 3. Controls: left/right arrow keys (or A/D) to move the paddle. Spacebar launches the ball from the start screen and also acts as pause.
> 4. Ball–paddle collision reflects the impact point: hitting the left edge sends the ball left, and vice versa.
> 5. Three lives. If the ball falls below the canvas, you lose a life and the ball resets on the paddle, waiting for spacebar to launch.
> 6. You win by destroying all bricks; you lose when you run out of lives.
> 7. Screens: start (title + "press space"), playing, game over, and victory. Game over/victory must allow restart with a click or key press.
> 8. HUD: score (10 points per brick) and remaining lives.
>
> **Technical restrictions:**
> - A single `.html` file, all CSS and JavaScript inline (vanilla JS, no frameworks or libraries).
> - Use `requestAnimationFrame` for the game loop with delta time (frame-rate independent speed).
> - No `<img>` tags or external assets; everything drawn with the Canvas API.
> - No placeholders or `// TODO`. The code must be complete and runnable.
>
> **Acceptance criteria (verify yourself before answering):**
> - [ ] Opening the file shows the start screen and the game runs without console errors.
> - [ ] The ball bounces correctly off walls, paddle, and bricks.
> - [ ] The bounce angle depends on the impact point on the paddle.
> - [ ] Bricks are destroyed, score increases, and lives decrease.
> - [ ] It is possible to win, lose, and restart.
>
> Reply with **only the complete code** inside a code block, with no preceding explanations.