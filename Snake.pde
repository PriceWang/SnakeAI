class Snake {

    PImage body = loadImage("body.png");
    PImage up  = loadImage("up.png");
    PImage down = loadImage("down.png");
    PImage left = loadImage("left.png");
    PImage right = loadImage("right.png");

    float gridWidth;
    PVector panelStart;
    PVector panelSize;
    char direction;
    boolean reset;
    boolean pause;
    int score;

    PVector snakeHead;  
    ArrayList<PVector> snakeBody;

    Food food;

    int gen = 0;

    Snake (float gridWidth, PVector panelStart, PVector panelSize) {
        this.gridWidth = gridWidth;
        this.panelStart = panelStart;
        this.panelSize = panelSize;
        reset = true;
        pause = true;
    }

    void initSnake() {
        direction = 'R';
        reset = false;
        pause = true;
        score = 0;

        snakeHead = new PVector(6, 3);
        snakeBody = new ArrayList<PVector>();
        snakeBody.add(new PVector(5, 3));
        snakeBody.add(new PVector(4, 3));

        food = new Food(gridWidth, panelStart, panelSize, snakeHead, snakeBody);
    }

    void moveStraight() {
        float tempX = snakeHead.x;
        float tempY = snakeHead.y;
        switch (direction) {
            case 'R':
                snakeHead.x++;
                break;
            case 'L':
                snakeHead.x--;
                break;
            case 'U':
                snakeHead.y--;
                break;
            case 'D':
                snakeHead.y++;
                break;	
        }
        float tempX2;
        float tempY2;
        for(int i = 0; i < snakeBody.size(); i++) {
            tempX2 = snakeBody.get(i).x;
            tempY2 = snakeBody.get(i).y;
            snakeBody.get(i).x = tempX;
            snakeBody.get(i).y = tempY;
            tempX = tempX2;
            tempY = tempY2;
        } 
        if (eat(snakeHead)) {
            snakeBody.add(new PVector(tempX, tempY));
            food = new Food(gridWidth, panelStart, panelSize, snakeHead, snakeBody);
            score++;
        }
        if (collision()) {
            delay(1000);
            gen++;
            reset = true;
        }
    }

    void turnAround (char dire) {
        if (!((direction == 'U' && dire == 'D') || (direction == 'D' && dire == 'U') || (direction == 'R' && dire == 'L') || (direction == 'L' && dire == 'R'))) {
            direction = dire;
        }
    }

    boolean collision() {
        if (wallCollision(snakeHead) || bodyCollision(snakeHead, snakeBody))
            return true;
        return false;
    }

    boolean wallCollision (PVector head) {
        if (head.x < 0 || head.x >= panelSize.x || head.y < 0 || head.y >= panelSize.y) {
            return true;
        }
        return false;
    }

    boolean bodyCollision (PVector head, ArrayList<PVector> body) {
        if (body.contains(head)) {
            return true;
        }
        return false;
    }

    boolean eat (PVector head) {
        return head.equals(food.pos);
    }

    boolean eat () {
        return snakeHead.equals(food.pos);
    }

    float[] getState() {       
        float[] temp = new float[3];
        float[] state = new float[24];
        
        temp = lookInOneDirection(new PVector(0, 1));
        state[0] = temp[0];
        state[1] = temp[1];
        state[2] = temp[2];

        temp = lookInOneDirection(new PVector(0, -1));
        state[3] = temp[0];
        state[4] = temp[1];
        state[5] = temp[2];

        temp = lookInOneDirection(new PVector(1, 0));
        state[6] = temp[0];
        state[7] = temp[1];
        state[8] = temp[2];

        temp = lookInOneDirection(new PVector(-1, 0));
        state[9] = temp[0];
        state[10] = temp[1];
        state[11] = temp[2];

        temp = lookInOneDirection(new PVector(1, 1));
        state[12] = temp[0];
        state[13] = temp[1];
        state[14] = temp[2];

        temp = lookInOneDirection(new PVector(1, -1));
        state[15] = temp[0];
        state[16] = temp[1];
        state[17] = temp[2];

        temp = lookInOneDirection(new PVector(-1, 1));
        state[18] = temp[0];
        state[19] = temp[1];
        state[20] = temp[2];

        temp = lookInOneDirection(new PVector(-1, -1));
        state[21] = temp[0];
        state[22] = temp[1];
        state[23] = temp[2];


        return state;        
    }

    float[] lookInOneDirection(PVector dire) {
        float[] temp = new float[3];
        float distance = 0;
        PVector pos = new PVector(snakeHead.x, snakeHead.y);
        while (!wallCollision(pos)) {
            if (eat(pos)) {
                temp[0] = distance;
            }
            if (bodyCollision(pos, snakeBody)) {
                temp[1] = distance;
            }
            pos.add(dire);
            distance++;
        }
        temp[2] = distance;
        return temp;
    }

    void show() {
        PImage img = new PImage();
        switch (direction) {
            case 'R':
                img = right;
                break;
            case 'L':
                img = left;
                break;
            case 'U':
                img = up;
                break;
            case 'D':
                img = down;
                break;	
        }

        image(img, panelStart.x + snakeHead.x * gridWidth, panelStart.y + snakeHead.y * gridWidth, gridWidth, gridWidth);

        for (int i = 0; i < snakeBody.size(); i++) {
            image(body, panelStart.x + snakeBody.get(i).x * gridWidth, panelStart.y + snakeBody.get(i).y * gridWidth, gridWidth, gridWidth);
        }

        food.show();
    }

}
