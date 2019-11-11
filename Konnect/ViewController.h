//
//  ViewController.h
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Introduction;
@class Home;
@class AppDelegate;
@class Header;
@class MessageList;
@class MessageDetails;
@class Footer;
@class ScanQR;
@class My;
@class EditInfo;
@class Wallet;
@class PointsHistory;
@class TopUp;
@class ChargeQR;
@class PaymentCode;
@class Facility;
@class ImageList;
@class Booking;
@class ORWebViewController;
@class FacilityList;
@class ServiceOffice;
@class ContactUs;
@class Invoices;
@class PastInvoices;
@class Invoice;
@class RefereralQR;
@class Company;
@class Office;
@class SearchMeetingRoom;
@class KonnectNews;
@class AboutKonnect;
@class Events;
@class EventDetails;
@class Coupons;
@class Reservations;
@interface ViewController : UIViewController {
    Introduction *lc;
    UINavigationController *nav;
    Home *home;
    AppDelegate *delegate;
    Header *header;
    Footer *footer;
    MessageList *messageList;
    MessageDetails *messageDetails;
    ScanQR *scanqr;
    ChargeQR *chargeqr;
    My *my;
    EditInfo *editinfo;
    Wallet *wallet;
    PointsHistory *points;
    TopUp *topup;
    PaymentCode *paymentcode;
    Facility *facility;
    ImageList *imgList;
    Booking *booking;
    ORWebViewController *tou;
    FacilityList *faciliites;
    ServiceOffice *serviceOffice;
    ContactUs *contact;
    Invoices *invoice;
    PastInvoices *pastinvoice;
    Invoice *inv;
    RefereralQR *refqr;
    Company *company;
    Office *office;
    SearchMeetingRoom *searchroom;
    KonnectNews *knews;
    AboutKonnect *about;
    Events *event;
    EventDetails *eventdetails;
    Coupons *coupon;
    Reservations *reservation;
    
}
-(void) onBackPressed;

@end

