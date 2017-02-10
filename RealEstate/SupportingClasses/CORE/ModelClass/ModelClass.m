//
//  ModelClass.m
//  APITest
//
//  Created by Evgeny Kalashnikov on 03.12.11.
//  Copyright 2011 MyCompanyName. All rights reserved.
//

#import "ModelClass.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "DarckWaitView.h"
#import "UIAlertHelper.h"
@implementation ModelClass {
    NSString *customer;
}

@synthesize delegate = _delegate;
@synthesize success;

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

- (id)init
{
    self = [super init];
    if (self) {
        parser = [[SBJSON alloc] init];
        success = NO;
        drk = [[DarckWaitView alloc] initWithDelegate:nil andInterval:0.1 andMathod:nil];
        customer=[[NSString alloc]init];
    }
    return self;
}

-(NSString *) base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [drk hide];
    [UIAlertHelper showAlert:[LOCALIZATION localizedStringForKey:@"noconection"]];
    
}

- (void)userLogin:(NSString *)email
       password:(NSString*)password
      is_social:(NSString*)is_social
    social_type:(NSString*)social_type
      social_id:(NSString*)social_id
       selector:(SEL)sel{
    login = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Users/login"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:is_social forKey:@"is_social"];
    [request setPostValue:social_type forKey:@"social_type"];
    [request setPostValue:social_id forKey:@"social_id"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}

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
       selector:(SEL)sel
{
    registerUser= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Users/register"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
   
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:firstname forKey:@"firstname"];
    [request setPostValue:lastname forKey:@"lastname"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:username forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:mobile forKey:@"mobile"];
    [request setPostValue:city forKey:@"city"];
    [request setPostValue:state forKey:@"state"];
    [request setPostValue:country forKey:@"country"];
    [request setPostValue:address forKey:@"address"];
    [request setPostValue:device_id forKey:@"device_id"];
    [request setPostValue:userid forKey:@"userid"];
    [request setPostValue:is_socialuser forKey:@"is_socialuser"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
 //   NSData *imgData=[[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];

//    [request addData:imgData withFileName: [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%u",arc4random()]] andContentType:@"image/jpeg" forKey:@"data[image]"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}
- (void)propertyList:(NSString *)start forUserid:(NSString *)userid selector:(SEL)sel
{
    properList = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/list"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:start forKey:@"start"];
    [request setPostValue:userid forKey:@"userid"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    [request setDelegate:self];
    [request startAsynchronous];
    
    if ([start intValue] == 0) {
        [drk showWithMessage:nil];
    }
    
}
-(void)getCategories:(SEL)sel{
    getCate = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Feedbacks/categorylist"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
    
}
-(void)getCurrentPlace:(CGFloat)latitude longitude:(CGFloat)longitude selector:(SEL)sel{
    
    getCurrentPlace = sel;
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",latitude,longitude]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)propertyDetails:(NSString *)property_id selector:(SEL)sel
{
    propertyDetail = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/detail"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:property_id forKey:@"property_id"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}
- (void)socialLogin:(NSString *)social_type  social_data:(NSString*)social_data selector:(SEL)sel
{
    socialLogin = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Users/sociallogin"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
   
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:social_type forKey:@"social_type"];
    [request setPostValue:social_data forKey:@"social_data"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}
- (void)contactUs:(NSString *)userid  email:(NSString*)email message:(NSString*)message cateId:(NSString*)cateId selector:(SEL)sel
{
    contactUs = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Feedbacks/contactus"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:userid forKey:@"userid"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:cateId forKey:@"category_id"];
    
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}

- (void)searchProperty:(NSString *)searchtext  latitude:(NSString*)latitude longitude:(NSString*)longitude selector:(SEL)sel
{
    searchProperty = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/search"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:searchtext forKey:@"searchtext"];
    [request setPostValue:latitude forKey:@"latitude"];
    [request setPostValue:longitude forKey:@"longitude"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}
- (void)getTypes:(SEL)sel
{
    getTypes = sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/get"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}
//
- (void)searchFilter:(NSString *)price_from
            price_to:(NSString*)price_to
            location:(NSString*)location
       property_type:(NSString*)property_type
          other_type:(NSString*)other_type
         other_value:(NSString*)other_value
              zoning:(NSString*)zoning
            selector:(SEL)sel
{
    searchFilter= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/searchfilter"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    
  
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:price_from forKey:@"price_from"];
    [request setPostValue:price_to forKey:@"price_to"];
    [request setPostValue:location forKey:@"location"];
    [request setPostValue:property_type forKey:@"property_type"];
    [request setPostValue:other_type forKey:@"other_type"];
    [request setPostValue:other_value forKey:@"other_value"];
    [request setPostValue:zoning forKey:@"zoning"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
}

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
           selector:(SEL)sel
{
    addproperty= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"properties/add"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:propertyid forKey:@"propertyid"];
    [request setPostValue:userid forKey:@"userid"];
    [request setPostValue:title forKey:@"title"];
    [request setPostValue:price forKey:@"price"];
    [request setPostValue:location forKey:@"location"];
    [request setPostValue:city forKey:@"city"];
    [request setPostValue:@"" forKey:@"state"];
    [request setPostValue:country forKey:@"country"];
    [request setPostValue:@"" forKey:@"zipcode"];
    [request setPostValue:property_type forKey:@"type"];
    [request setPostValue:other_property_type forKey:@"other_value"];
    [request setPostValue:zoning forKey:@"zoning"];
    [request setPostValue:tags forKey:@"tags"];
    [request setPostValue:description forKey:@"description"];
    [request setPostValue:[images JSONRepresentation] forKey:@"property_image"];
    [request setPostValue:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [request setPostValue:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [DELEGATE.drk hide];
    [drk showWithMessage:nil];

}


- (void)deleteProperty:(NSString *)propertyid
                UserId:(NSString *)userid
              selector:(SEL)sel{

    deleteproperty= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"properties/delete"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:propertyid forKey:@"property_id"];
    [request setPostValue:userid forKey:@"userid"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];

}
-(void)addImage:(NSString *)imageid
     propertyid:(NSString *)propertyid
         userid:(NSString*)userid
          image:(UIImage *)image_new
       selector:(SEL)sel{
    
    addImage= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Properties/addimage"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:imageid forKey:@"imageid"];
    [request setPostValue:propertyid forKey:@"propertyid"];
    [request setPostValue:userid forKey:@"userid"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
   
    [request addData:UIImageJPEGRepresentation(([self scaleAndRotateImage:image_new]), 1) withFileName: [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%u",arc4random()]] andContentType:@"image/jpeg" forKey:@"data[url]"];
    

    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
    
}

-(void)sendEmail:(NSString *)from_email
        to_email:(NSString *)to_email
         message:(NSString*)message
         subject:(NSString*)subject
        selector:(SEL)sel{
    
    sendEmail= sel;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_PATH,@"Messages/msgadd"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:from_email forKey:@"from_email"];
    [request setPostValue:to_email forKey:@"to_email"];
    [request setPostValue:message forKey:@"message"];
    [request setPostValue:subject forKey:@"subject"];
    if ([USER_DEFAULTS valueForKey:@"localization"]) {
        
        if ([[USER_DEFAULTS valueForKey:@"localization"] isEqualToString:@"AR"]) {
            [request setPostValue:@"ar" forKey:@"ln"];
        }else{
            [request setPostValue:@"" forKey:@"ln"];
        }
    }else{
        [request setPostValue:@"" forKey:@"ln"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [drk showWithMessage:nil];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSString *func = [self getFunc:[request url]];
    if ([func isEqual:@"login"])
    {
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:login withObject:resDict];
        [drk hide];
        
    }else if ([func isEqual:@"register"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:registerUser withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"list"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:properList withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"detail"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:propertyDetail withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"sociallogin"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:socialLogin withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"contactus"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:contactUs withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"search"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:searchProperty withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"get"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:getTypes withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"searchfilter"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:searchFilter withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"add"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:addproperty withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"delete"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:deleteproperty withObject:resDict];
        [drk hide];
    }else if ([[NSString stringWithFormat:@"%@",[request url]] rangeOfString:@"google"].location != NSNotFound) {
        
        NSMutableDictionary  *currentPlace=[[NSMutableDictionary alloc]init];
        NSMutableDictionary  *address=[[NSMutableDictionary alloc]init];
        NSString *result1 = [[parser objectWithString:[request responseString] error:nil] objectForKey:@"status"];
        NSDictionary *resDict1 = [parser objectWithString:[request responseString] error:nil];
        
        if ([result1 isEqualToString:@"OK"]) {
            NSMutableArray *address_components=[[NSMutableArray alloc]initWithArray:[[[resDict1 valueForKey:@"results"]objectAtIndex:0]valueForKey:@"address_components"]];
            for (int i=0; i<address_components.count; i++) {
                [address setObject:[[address_components objectAtIndex:i]valueForKey:@"long_name"] forKey:[[[address_components objectAtIndex:i]valueForKey:@"types"]objectAtIndex:0]];
            }
            currentPlace=[[resDict1 valueForKey:@"results"]objectAtIndex:0];
            [currentPlace setValue:address forKey:@"address"];
        }
        
        [self.delegate performSelector:getCurrentPlace withObject:currentPlace];
        [drk hide];
    }else if ([func isEqual:@"addimage"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:addImage withObject:resDict];
        [drk hide];
    }else if ([func isEqual:@"msgadd"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:sendEmail withObject:resDict];
        [drk hide];
    } else if ([func isEqual:@"categorylist"]){
        NSDictionary *resDict = [parser objectWithString:[request responseString] error:nil];
        [self.delegate performSelector:getCate withObject:resDict];
        [drk hide];
    }
    
}

- (NSString *) getFunc:(NSURL *)url {
    NSString *str = [NSString stringWithFormat:@"%@",url];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"/"]];
    return [arr lastObject];
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{ // here we rotate the image in its orignel
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
@end
