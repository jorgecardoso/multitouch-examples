class CursorEventDetector extends java.util.Observable {

    HashMap<Integer, TuioCursor> cursors = new HashMap();
    HashMap<Integer, EventTimerTask> timers = new HashMap();

    int LONGPRESS_DELAY = 600;
    java.util.Timer timer;
    
    CursorEventDetector() {
        timer = new java.util.Timer();
    }

    void addCursor(TuioCursor c) {
        cursors.put(c.getCursorID(), new TuioCursor(c));
        setChanged();
        notifyObservers(new CursorEvent(EventType.DOWN, c));

        EventTimerTask ett = new EventTimerTask(this, c);
        timers.put(c.getCursorID(), ett);
        timer.schedule(ett, LONGPRESS_DELAY);
    }

    void updateCursor(TuioCursor c) {
        TuioCursor prev = cursors.get(c.getCursorID());
        
        if ( c.isMoving() ) {
            setChanged();
            notifyObservers(new CursorEvent(EventType.DRAG, c));

            // cancel longpress
            timers.get(c.getCursorID()).cancel();
        }
    }

    void removeCursor(TuioCursor c) {
        TuioCursor downCursor = cursors.get(c.getCursorID());
        
        // cancel longpress
        timers.get(c.getCursorID()).cancel();

        cursors.remove(c.getCursorID());
        
       
        // Click events are only triggered if cursor released near the down point and no LONGPRESS emmited yet.
        if (dist(downCursor.getX(), downCursor.getY(), c.getX(), c.getY()) < 0.01 &&
        (c.getTuioTime().getTotalMilliseconds()-c.getStartTime().getTotalMilliseconds()) < LONGPRESS_DELAY) {
            setChanged();
            notifyObservers(new CursorEvent(EventType.CLICK, c));
        }
        
        setChanged();
        notifyObservers(new CursorEvent(EventType.UP, c));
    }


    class EventTimerTask extends java.util.TimerTask {
        TuioCursor cursor;
        CursorEventDetector cursorEventDetector;
        public EventTimerTask(CursorEventDetector detector, TuioCursor c) {
            cursor = c;
            cursorEventDetector = detector;
        }

        void run() {
            cursorEventDetector.setChanged();
            cursorEventDetector.notifyObservers(new CursorEvent(EventType.LONGPRESS, cursor));
        }
    }
}


class CursorEvent {
    EventType type;
    TuioCursor cursor;
    
    CursorEvent(EventType t, TuioCursor c) {
        type = t;
        cursor = c;
    }

    String toString() {
        return "CursorEvent [" + type.toString() + "]";
    }
} 

public enum EventType {
    DOWN, UP, CLICK, DRAG, LONGPRESS
}
