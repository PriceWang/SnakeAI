class Food {

    PImage food = loadImage("food.png");

    PVector pos;
    float x, y;
    float gridWidth, startX, startY;

    Food (float gridWidth, PVector panelStart, PVector panelSize, PVector snakeHead, ArrayList<PVector> snakeBody) {
        this.gridWidth = gridWidth;
        startX = panelStart.x;
        startY = panelStart.y;

        x = floor(random(panelSize.x));
        y = floor(random(panelSize.y));
        pos = new PVector(x, y);

        while (pos.equals(snakeHead) || snakeBody.contains(pos)) {
            x = floor(random(panelSize.x));
            y = floor(random(panelSize.y));
            pos = new PVector(x, y);
        }
        
    }

    void show() {
        image(food, startX + pos.x * gridWidth, startY + pos.y * gridWidth, gridWidth, gridWidth);
    }

}
