//
//  ModelClass.h
//  APITest
//
//  Created by Evgeny Kalashnikov on 03.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ModelClass.h"
@class DarckWaitView;

@interface ModelClass : NSObject {
    SBJSON *parser;
    DarckWaitView *drk;
    SEL login;
    SEL registerUser;
    SEL properList;
    SEL propertyDetail;
    SEL socialLogin;
    SEL contactUs;
    SEL searchProperty;
    SEL getTypes;
    SEL searchFilter;
    SEL addproperty;
    SEL deleteproperty;
    SEL getCurrentPlace;
    SEL addImage;
    SEL sendEmail;
    SEL getCate;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, readwrite) BOOL success;
-(void)sendEmail:(NSString *)from_email
        to_email:(NSString *)to_email
         message:(NSString*)message
         subject:(NSString*)subject
        selector:(SEL)sel;
-(void)getCurrentPlace:(CGFloat)latitude longitude:(CGFloat)longitude selector:(SEL)sel;
- (void)userLogin:(NSString *)email
       password:(NSString*)password
      is_social:(NSString*)is_social
    social_type:(NSString*)social_type
      social_id:(NSString*)social_id
       selector:(SEL)sel;

- (void)regiter:(NSString *)firstname
       lastname:(NSString*)lastname
          email:(NSString*)email
       username:(NSString*)username
       password:(NSString*)password
         mobile:(NSString*)mobile
           city:(NSString*)city
          state:(NSString*)state
        country:(NSString*)country
        address:(NSString*)address
      device_id:(NSString*)device_id
         userid:(NSString*)userid
          image:(UIImage*)image
  is_socialuser:(NSString*)is_socialuser
       selector:(SEL)sel;

- (void)propertyList:(NSString *)start forUserid:(NSString *)userid selector:(SEL)sel;
- (void)propertyDetails:(NSString *)property_id selector:(SEL)sel;
- (void)socialLogin:(NSString *)social_type  social_data:(NSString*)social_data selector:(SEL)sel;
- (void)contactUs:(NSString *)userid  email:(NSString*)email message:(NSString*)message cateId:(NSString*)cateId selector:(SEL)sel;
- (void)searchProperty:(NSString *)searchtext  latitude:(NSString*)latitude longitude:(NSString*)longitude selector:(SEL)sel;
- (void)getTypes:(SEL)sel;
- (void)searchFilter:(NSString *)price_from
            price_to:(NSString*)price_to
            location:(NSString*)location
       property_type:(NSString*)property_type
          other_type:(NSString*)other_type
         other_value:(NSString*)other_value
              zoning:(NSString*)zoning
            selector:(SEL)sel;

- (void)addProperty:(NSString *)propertyid
             UserId:(NSString *)userid
              Title:(NSString *)title
              Price:(NSString *)price
           Location:(NSString *)location
               City:(NSString *)city
              State:(NSString *)state
            Country:(NSString *)country
            Zipcode:(NSString *)zipcode
       PropertyType:(NSString *)property_type
Other_Property_Type:(NSString *)other_property_type
             Zoning:(NSString *)zoning
               Tags:(NSString *)tags
        Description:(NSString *)description
             Images:(NSMutableArray *)images
           latitude:(CGFloat)latitude
          longitude:(CGFloat)longitude
           selector:(SEL)sel;

- (void)deleteProperty:(NSString *)propertyid
             UserId:(NSString *)userid
           selector:(SEL)sel;

-(void)addImage:(NSString *)imageid
     propertyid:(NSString *)propertyid
         userid:(NSString*)userid
          image:(UIImage *)image_new
       selector:(SEL)sel;
-(void)getCategories:(SEL)sel;


@end
