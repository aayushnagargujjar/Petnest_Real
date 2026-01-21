
class Appointment {
    final int id;
    final String petName;
    final String ownerName;
    final String service;
    final String time;
    final String status; // 'Confirmed' | 'Pending'

    Appointment({
        required this.id,
        required this.petName,
        required this.ownerName,
        required this.service,
        required this.time,
        required this.status,
    });
}

class SellerOrder {
    final int id;
    final String orderNumber;
    final String customerName;
    final String items;
    final double price;
    final String status; // 'New' | 'Packed'

    SellerOrder({
        required this.id,
        required this.orderNumber,
        required this.customerName,
        required this.items,
        required this.price,
        required this.status,
    });
}
