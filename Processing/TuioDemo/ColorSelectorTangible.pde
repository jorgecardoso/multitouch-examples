class ColorSelectorTangible {
    int objW = 100;
    int objH = 100;

    int colorButtonW = 33;
    int colorButtonH = 33;

    int objectId;
    TuioObject tuioObject = null;

    PVector objPos = null;
    PVector cursor;

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

    void addCursor(TuioCursor t) {
        if ( tuioObject == null ) return;
        PVector c = new PVector(t.getX()*width, t.getY()*height);
        cursor = PVector.sub( c, objPos);
        cursor.rotate(-tuioObject.getAngle());
    }

    void updateCursor(TuioCursor t) {
        if ( tuioObject == null ) return;
        PVector c = new PVector(t.getX()*width, t.getY()*height);
        
        cursor = PVector.sub( c, objPos);
        cursor.rotate(-tuioObject.getAngle());
        if (cursor.x > -objW/2 && cursor.x < -objW/2+colorButtonW &&
        cursor.y > -objH/2-colorButtonH && cursor.y < -objH/2) {
            objColor = color(233, 100, 40);
        } else {
            objColor = color(0);
        }
       
    }

    void removeCursor(TuioCursor t) {
        if ( tuioObject == null ) return;
        cursor = null;
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


            if (cursor != null ) {
                fill(255);
                ellipse(cursor.x, cursor.y, 5, 5);              
            }
            popStyle();
            popMatrix();
        }
    }
}
