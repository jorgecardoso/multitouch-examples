class ColorSelectorTangible implements java.util.Observer {
    int objW = 100;
    int objH = 100;

    int colorButtonW = 33;
    int colorButtonH = 33;

    int objectId;
    TuioObject tuioObject = null;

    PVector objPos = null;
   
    color objColor;
    ColorSelectorTangible(int objectId) {
        this.objectId = objectId;
        objColor = color(0);
    }

    void addObj(TuioObject t) {
        this.tuioObject = t;
        objPos = new PVector(t.getX()*width, t.getY()*height);
    }

    void updateObj(TuioObject t) {
        this.tuioObject = t;
        objPos = new PVector(t.getX()*width, t.getY()*height);
    }

    void removeObj() {
        this.tuioObject = null;
        objPos = null;
    }

    void update(java.util.Observable o, Object args) {
        if ( tuioObject == null ) return;
        
        CursorEvent ce = (CursorEvent)args;
        TuioCursor t = ce.cursor;
        switch (ce.type) {              
        case CLICK:
            PVector c = new PVector(t.getX()*width, t.getY()*height);

            PVector cursor = PVector.sub( c, objPos);
            cursor.rotate(-tuioObject.getAngle());
            if (cursor.x > -objW/2 && cursor.x < -objW/2+colorButtonW &&
                cursor.y > -objH/2-colorButtonH && cursor.y < -objH/2) {
                objColor = color(255, 0, 0);
            } else if (cursor.x > -objW/2+colorButtonW && cursor.x < -objW/2+2*colorButtonW &&
                cursor.y > -objH/2-colorButtonH && cursor.y < -objH/2) {
                objColor = color(255, 255, 0);
            } else if (cursor.x > -objW/2+2*colorButtonW && cursor.x < -objW/2+3*colorButtonW &&
                cursor.y > -objH/2-colorButtonH && cursor.y < -objH/2) {
                objColor = color(0, 255, 255);
            }
            break;
        case UP:
            cursor = null;
            break;
        default:
        }
        //println(ce);
    }

    void draw() {
        if (objPos != null) {
            pushMatrix();
            pushStyle();
            rectMode(CENTER);

            translate(objPos.x, objPos.y);
            rotate(tuioObject.getAngle());
            fill(objColor);
            rect(0, 0, objW, objH);

            fill(255, 0, 0);
            rect(-objW/2+colorButtonW/2, -objH/2-colorButtonH/2, colorButtonW, colorButtonH);

            fill(255, 255, 0);
            rect(-objW/2+1.5*colorButtonW, -objH/2-colorButtonH/2, colorButtonW, colorButtonH);

            fill(0, 255, 255);
            rect(-objW/2+2.5*colorButtonW, -objH/2-colorButtonH/2, colorButtonW, colorButtonH);

            
            popStyle();
            popMatrix();
        }
    }
}
