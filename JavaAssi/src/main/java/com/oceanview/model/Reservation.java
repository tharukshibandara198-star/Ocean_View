package com.oceanview.model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Reservation Model
 * ──────────────────
 * Represents a hotel booking/reservation record.
 *
 * Design Pattern: MVC - Model
 */
public class Reservation {

    private int        id;
    private String     reservationNo;   // e.g. OVR-00001 (auto-generated)
    private String     guestName;
    private String     address;
    private String     contactNo;
    private int        roomId;
    private Room       room;            // joined Room object (for display)
    private LocalDate  checkInDate;
    private LocalDate  checkOutDate;
    private BigDecimal totalCost;
    private String     status;          // CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED
    private int        createdBy;
    private String     createdByName;   // joined User.fullName (for display)

    // ── Constructors ──────────────────────────────────────────────────────────

    public Reservation() {}

    // ── Business helper: number of nights ────────────────────────────────────

    /**
     * Calculates the number of nights between check-in and check-out.
     * @return number of nights (minimum 1)
     */
    public long getNumberOfNights() {
        if (checkInDate != null && checkOutDate != null) {
            long nights = java.time.temporal.ChronoUnit.DAYS.between(checkInDate, checkOutDate);
            return nights > 0 ? nights : 1;
        }
        return 1;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int  getId()            { return id; }
    public void setId(int id)      { this.id = id; }

    public String getReservationNo()                       { return reservationNo; }
    public void   setReservationNo(String reservationNo)   { this.reservationNo = reservationNo; }

    public String getGuestName()                   { return guestName; }
    public void   setGuestName(String guestName)   { this.guestName = guestName; }

    public String getAddress()               { return address; }
    public void   setAddress(String address) { this.address = address; }

    public String getContactNo()                   { return contactNo; }
    public void   setContactNo(String contactNo)   { this.contactNo = contactNo; }

    public int  getRoomId()            { return roomId; }
    public void setRoomId(int roomId)  { this.roomId = roomId; }

    public Room getRoom()           { return room; }
    public void setRoom(Room room)  { this.room = room; }

    public LocalDate getCheckInDate()                      { return checkInDate; }
    public void      setCheckInDate(LocalDate checkInDate) { this.checkInDate = checkInDate; }

    public LocalDate getCheckOutDate()                       { return checkOutDate; }
    public void      setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }

    public BigDecimal getTotalCost()                       { return totalCost; }
    public void       setTotalCost(BigDecimal totalCost)   { this.totalCost = totalCost; }

    public String getStatus()              { return status; }
    public void   setStatus(String status) { this.status = status; }

    public int  getCreatedBy()                 { return createdBy; }
    public void setCreatedBy(int createdBy)    { this.createdBy = createdBy; }

    public String getCreatedByName()                       { return createdByName; }
    public void   setCreatedByName(String createdByName)   { this.createdByName = createdByName; }

    @Override
    public String toString() {
        return "Reservation{id=" + id + ", reservationNo='" + reservationNo
               + "', guestName='" + guestName + "', status='" + status + "'}";
    }
}
