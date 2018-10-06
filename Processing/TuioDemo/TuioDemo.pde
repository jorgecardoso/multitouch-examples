 //<>// //<>//
// import the TUIO library
import TUIO.*;

TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursorSize = 15;
float objectSize = 60;
float tableHeight = 760;
float scaleFactor = 1;
PFont font;

boolean verbose = false; // print console debug messages

CursorEventDetector cursorEventDetector = new CursorEventDetector();

ColorSelectorTangible[] colorTangibles;

void setup()
{

    size(600, 400);
    noStroke();
    fill(0);

    font = createFont("Arial", 18);
    scaleFactor = height/tableHeight;

    tuioClient  = new TuioProcessing(this);

    colorTangibles = new ColorSelectorTangible[2];

    colorTangibles[0] = new ColorSelectorTangible(4);
    colorTangibles[1] = new ColorSelectorTangible(5);

    for (int i = 0; i < colorTangibles.length; i++) {
        cursorEventDetector.addObserver(colorTangibles[i]);
    }
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw()
{
    background(200);
    textFont(font, 18*scaleFactor);
    float objSize = objectSize*scaleFactor; 
    float curSize = cursorSize*scaleFactor; 
    for (int i = 0; i < colorTangibles.length; i++) {
        colorTangibles[i].draw();
    }

    ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
    for (int i=0; i<tuioCursorList.size(); i++) {
        TuioCursor tcur = tuioCursorList.get(i);
        ArrayList<TuioPoint> pointList = tcur.getPath();

        if (pointList.size()>0) {
            stroke(0, 0, 255);
            TuioPoint start_point = pointList.get(0);
            for (int j=0; j<pointList.size(); j++) {
                TuioPoint end_point = pointList.get(j);
                line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
                start_point = end_point;
            }

            stroke(64, 0, 64);
            fill(64, 0, 64);
            ellipse( tcur.getScreenX(width), tcur.getScreenY(height), curSize, curSize);
            fill(0);
            text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
        }
    }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
    if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());

    for (int i = 0; i < colorTangibles.length; i++) {
        if ( tobj.getSymbolID() == colorTangibles[i].objectId) {
            colorTangibles[i].addObj(tobj);
        }
    }
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
    if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
        +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
    for (int i = 0; i < colorTangibles.length; i++) {
        if ( tobj.getSymbolID() == colorTangibles[i].objectId) {
            colorTangibles[i].updateObj(tobj);
        }
    }
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
    if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
    for (int i = 0; i < colorTangibles.length; i++) {
        if ( tobj.getSymbolID() == colorTangibles[i].objectId) {
            colorTangibles[i].removeObj();
        }
    }
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {

    if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
    //redraw();
    cursorEventDetector.addCursor(tcur);

    // colorTangible.addCursor(tcur);
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
    // println(tcur.getStartTime().getTotalMilliseconds(), tcur.getTuioTime().getTotalMilliseconds());
    if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
        +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
    //redraw();
    cursorEventDetector.updateCursor(tcur);

    // colorTangible.updateCursor(tcur);
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
    if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
    //redraw()
    cursorEventDetector.removeCursor(tcur);
    //  colorTangible.removeCursor(tcur);
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
    if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
    //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
    if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
        +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
    //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
    if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
    //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
    if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
}
