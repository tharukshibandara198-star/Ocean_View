package com.oceanview.model;

import java.math.BigDecimal;

/**
 * Room Model
 * ───────────
 * Represents a hotel room with its type and nightly rate.
 *
 * Design Pattern: MVC - Model
 */
public class Room {

    private int        id;
    private String     roomNumber;
    private String     roomType;       // Standard, Deluxe, Suite, Ocean View
    private BigDecimal ratePerNight;
    private String     description;
    private boolean    isAvailable;

    // ── Constructors ──────────────────────────────────────────────────────────

    public Room() {}

    public Room(int id, String roomNumber, String roomType,
                BigDecimal ratePerNight, String description, boolean isAvailable) {
        this.id           = id;
        this.roomNumber   = roomNumber;
        this.roomType     = roomType;
        this.ratePerNight = ratePerNight;
        this.description  = description;
        this.isAvailable  = isAvailable;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int  getId()            { return id; }
    public void setId(int id)      { this.id = id; }

    public String getRoomNumber()                    { return roomNumber; }
    public void   setRoomNumber(String roomNumber)   { this.roomNumber = roomNumber; }

    public String getRoomType()                  { return roomType; }
    public void   setRoomType(String roomType)   { this.roomType = roomType; }

    public BigDecimal getRatePerNight()                        { return ratePerNight; }
    public void       setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }

    public String getDescription()                     { return description; }
    public void   setDescription(String description)   { this.description = description; }

    public boolean isAvailable()                    { return isAvailable; }
    public void    setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }

    @Override
    public String toString() {
        return "Room{id=" + id + ", roomNumber='" + roomNumber
               + "', roomType='" + roomType + "', rate=" + ratePerNight + "}";
    }
}
