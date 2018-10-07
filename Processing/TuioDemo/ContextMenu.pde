class ContextMenu implements java.util.Observer {

    String[] options;

    boolean showing = true;

    int menuWidth = 0, menuHeight = 0;
    int itemHeight = 0;
    int borderWidth = 10;
    int borderHeight = 5;

    PVector position = new PVector(100, 100);

    ContextMenu(String[] options) {
        this.options = options;

        itemHeight = (int)(textAscent() + textDescent());
        itemHeight += borderHeight * 2;

        menuHeight = itemHeight * options.length;

        for (int i = 0; i < options.length; i++) {

            float w = textWidth(options[i]);
            if (w > menuWidth) {
                menuWidth = (int)w;
            }
        }

        menuWidth += borderWidth * 2;
    }

    void update(java.util.Observable o, Object args) {

        CursorEvent ce = (CursorEvent)args;

        println(ce);
        TuioCursor t = ce.cursor;
        switch (ce.type) {              
        case LONGPRESS:
            position = new PVector(t.getX()*width, t.getY()*height);   
            showing = true;
            break;
        case CLICK:
            PVector p = new PVector(t.getX()*width, t.getY()*height); 
            println(position);
            println(p);
            if (p.x > position.x && p.x < position.x+menuWidth && p.y > position.y && p.y < position.y+menuHeight) {
                int itemClicked = int(p.y-position.y) / itemHeight;
                println("CLicked item", itemClicked, options[itemClicked]);
            } else if (p.x > position.x-menuWidth && p.x < position.x+menuWidth*2 && 
                p.y > position.y-menuHeight && p.y < position.y+menuHeight*2) {
                showing = false;
            }
            break;
        default:
        }
       
    }

    void draw() {
        if (showing) {
            pushMatrix();
            pushStyle();

            translate(position.x, position.y);

            noFill();
            stroke(200, 50, 0);
            for (int i = 0; i < options.length; i++) {
                rect(0, i*itemHeight, menuWidth, itemHeight);
                text(options[i], borderWidth, i*itemHeight+itemHeight-borderHeight-textDescent());
            }


            popStyle();
            popMatrix();
        }
    }
}
