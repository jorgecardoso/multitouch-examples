class CursorEventDetector extends java.util.Observable {

    HashMap<Integer, TuioCursor> cursors = new HashMap();
    HashMap<Integer, EventTimerTask> timers = new HashMap();

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
        timer.schedule(ett, 1000);
    }

    void updateCursor(TuioCursor c) {
        TuioCursor prev = cursors.get(c.getCursorID());
        //println(prev, c);
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
        

        if (dist(downCursor.getX(), downCursor.getY(), c.getX(), c.getY()) < 0.01) {
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
