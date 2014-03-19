//
//  SettingsTool.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/26/13.
//
//

#import "SettingsTool.h"
#import "AppDelegate.h"
#import <sys/sysctl.h>

@implementation SettingsTool {
    NSShadow *blackShadowForText;
    NSArray *iconImages;
}

static SettingsTool *sharedSettingsManager = nil;



+ (SettingsTool*)settings
{
    if (sharedSettingsManager == nil) {
        sharedSettingsManager = [[super allocWithZone:NULL] init];
          
    }
    
    return sharedSettingsManager ;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self settings];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
-(UIColor*)colorWithHexString:(NSString*)hex withAlpha:(float)alpha {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    // strip # if it appears
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

-(UIColor *)stdBackgroundColor {
    return [UIColor colorWithWhite:1.0 alpha:1.0];
}

-(UIColor *)inputBackgroundColor {
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    return [self colorWithHexString:hex withAlpha:1.0f];
}

-(NSShadow *)getBlackShadowForText {
    if (!blackShadowForText) {
        blackShadowForText = [[NSShadow alloc] init];
        blackShadowForText.shadowColor = [self colorWithHexString:@"#000000"];
        blackShadowForText.shadowOffset = CGSizeMake(1,1.0f);
    }
    return blackShadowForText;
}

-(NSString *)docsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(UIImage *)randomButtonImage {
    if (!iconImages) {
        [self setupIconImages];
    }
    
    NSUInteger top = [iconImages count] - 1;
    return [UIImage imageNamed:[iconImages objectAtIndex:arc4random_uniform((unsigned int)top)]];
}

-(NSArray *)buttonImages {
    if (!iconImages) {
        [self setupIconImages];
    }
    
    return iconImages;
}

-(void)setupIconImages {
    iconImages = [[NSArray alloc] initWithObjects:
                  @"A_Armor04.png",
                  @"A_Armor05.png",
                  @"A_Armour01.png",
                  @"A_Armour02.png",
                  @"A_Armour03.png",
                  @"A_Clothing01.png",
                  @"A_Clothing02.png",
                  @"A_Shoes01.png",
                  @"A_Shoes02.png",
                  @"A_Shoes03.png",
                  @"A_Shoes04.png",
                  @"A_Shoes05.png",
                  @"A_Shoes06.png",
                  @"A_Shoes07.png",
                  @"Ac_Earing01.png",
                  @"Ac_Earing02.png",
                  @"Ac_Gloves01.png",
                  @"Ac_Gloves02.png",
                  @"Ac_Gloves03.png",
                  @"Ac_Gloves04.png",
                  @"Ac_Gloves05.png",
                  @"Ac_Gloves06.png",
                  @"Ac_Gloves07.png",
                  @"Ac_Medal01.png",
                  @"Ac_Medal02.png",
                  @"Ac_Medal03.png",
                  @"Ac_Medal04.png",
                  @"Ac_Necklace01.png",
                  @"Ac_Necklace02.png",
                  @"Ac_Necklace03.png",
                  @"Ac_Necklace04.png",
                  @"Ac_Ring01.png",
                  @"Ac_Ring02.png",
                  @"Ac_Ring03.png",
                  @"Ac_Ring04.png",
                  @"C_Elm01.png",
                  @"C_Elm02.png",
                  @"C_Elm03.png",
                  @"C_Elm04.png",
                  @"C_Hat01.png",
                  @"C_Hat02.png",
                  @"C_Hat03.png",
                  @"Cloud_48x48.png",
                  @"Cloud_Sun_48x48.png",
                  @"Drought_Leaf_48x48.png",
                  @"E_Bones01.png",
                  @"E_Bones02.png",
                  @"E_Bones03.png",
                  @"E_Gold01.png",
                  @"E_Gold02.png",
                  @"E_Metal01.png",
                  @"E_Metal02.png",
                  @"E_Metal03.png",
                  @"E_Metal04.png",
                  @"E_Metal05.png",
                  @"E_Wood01.png",
                  @"E_Wood02.png",
                  @"E_Wood03.png",
                  @"E_Wood04.png",
                  @"Green_Leaf_48x48.png",
                  @"I_Agate.png",
                  @"I_Amethist.png",
                  @"I_Antidote.png",
                  @"I_BatWing.png",
                  @"I_BirdsBeak.png",
                  @"I_Bone.png",
                  @"I_Book.png",
                  @"I_Bottle01.png",
                  @"I_Bottle02.png",
                  @"I_Bottle03.png",
                  @"I_Bottle04.png",
                  @"I_BronzeBar.png",
                  @"I_BronzeCoin.png",
                  @"I_C_Apple.png",
                  @"I_C_Banana.png",
                  @"I_C_Bread.png",
                  @"I_C_Carrot.png",
                  @"I_C_Cheese.png",
                  @"I_C_Cherry.png",
                  @"I_C_Egg.png",
                  @"I_C_Fish.png",
                  @"I_C_Grapes.png",
                  @"I_C_GreenGrapes.png",
                  @"I_C_GreenPepper.png",
                  @"I_C_Lemon.png",
                  @"I_C_Meat.png",
                  @"I_C_Mulberry.png",
                  @"I_C_Mushroom.png",
                  @"I_C_Nut.png",
                  @"I_C_Orange.png",
                  @"I_C_Pear.png",
                  @"I_C_Pie.png",
                  @"I_C_Pineapple.png",
                  @"I_C_Radish.png",
                  @"I_C_RawFish.png",
                  @"I_C_RawMeat.png",
                  @"I_C_RedPepper.png",
                  @"I_C_Strawberry.png",
                  @"I_C_UnripeApple.png",
                  @"I_C_Watermellon.png",
                  @"I_C_YellowPepper.png",
                  @"I_Cannon01.png",
                  @"I_Cannon02.png",
                  @"I_Cannon03.png",
                  @"I_Cannon04.png",
                  @"I_Cannon05.png",
                  @"I_Chest01.png",
                  @"I_Chest02.png",
                  @"I_Coal.png",
                  @"I_Crystal01.png",
                  @"I_Crystal02.png",
                  @"I_Crystal03.png",
                  @"I_Diamond.png",
                  @"I_Eye.png",
                  @"I_Fabric.png",
                  @"I_Fang.png",
                  @"I_Feather01.png",
                  @"I_Feather02.png",
                  @"I_FishTail.png",
                  @"I_FoxTail.png",
                  @"I_FrogLeg.png",
                  @"I_GoldBar.png",
                  @"I_GoldCoin.png",
                  @"I_Ink.png",
                  @"I_IronBall.png",
                  @"I_Jade.png",
                  @"I_Key01.png",
                  @"I_Key02.png",
                  @"I_Key03.png",
                  @"I_Key04.png",
                  @"I_Key05.png",
                  @"I_Key06.png",
                  @"I_Key07.png",
                  @"I_Leaf.png",
                  @"I_Map.png",
                  @"I_Mirror.png",
                  @"I_Opal.png",
                  @"I_Rock01.png",
                  @"I_Rock02.png",
                  @"I_Rock03.png",
                  @"I_Rock04.png",
                  @"I_Rock05.png",
                  @"I_Rubi.png",
                  @"I_Saphire.png",
                  @"I_ScorpionClaw.png",
                  @"I_Scroll.png",
                  @"I_Scroll02.png",
                  @"I_SilverBar.png",
                  @"I_SilverCoin.png",
                  @"I_SnailShell.png",
                  @"I_SolidShell.png",
                  @"I_Telescope.png",
                  @"I_Tentacle.png",
                  @"I_Torch01.png",
                  @"I_Torch02.png",
                  @"I_Water.png",
                  @"I_WolfFur.png",
                  @"Mountain_48x48.png",
                  @"P_Blue01.png",
                  @"P_Blue02.png",
                  @"P_Blue03.png",
                  @"P_Blue04.png",
                  @"P_Green01.png",
                  @"P_Green02.png",
                  @"P_Green03.png",
                  @"P_Green04.png",
                  @"P_Medicine01.png",
                  @"P_Medicine02.png",
                  @"P_Medicine03.png",
                  @"P_Medicine04.png",
                  @"P_Medicine05.png",
                  @"P_Medicine06.png",
                  @"P_Medicine07.png",
                  @"P_Medicine08.png",
                  @"P_Medicine09.png",
                  @"P_Orange01.png",
                  @"P_Orange02.png",
                  @"P_Orange03.png",
                  @"P_Orange04.png",
                  @"P_Pink01.png",
                  @"P_Pink02.png",
                  @"P_Pink03.png",
                  @"P_Pink04.png",
                  @"P_Red01.png",
                  @"P_Red02.png",
                  @"P_Red03.png",
                  @"P_Red04.png",
                  @"P_White01.png",
                  @"P_White02.png",
                  @"P_White03.png",
                  @"P_White04.png",
                  @"P_Yellow01.png",
                  @"P_Yellow02.png",
                  @"P_Yellow03.png",
                  @"P_Yellow04.png",
                  @"S_Bow01.png",
                  @"S_Bow02.png",
                  @"S_Bow03.png",
                  @"S_Bow04.png",
                  @"S_Bow05.png",
                  @"S_Bow06.png",
                  @"S_Bow07.png",
                  @"S_Bow08.png",
                  @"S_Bow09.png",
                  @"S_Bow10.png",
                  @"S_Bow11.png",
                  @"S_Bow12.png",
                  @"S_Bow13.png",
                  @"S_Bow14.png",
                  @"S_Buff01.png",
                  @"S_Buff02.png",
                  @"S_Buff03.png",
                  @"S_Buff04.png",
                  @"S_Buff05.png",
                  @"S_Buff06.png",
                  @"S_Buff07.png",
                  @"S_Buff08.png",
                  @"S_Buff09.png",
                  @"S_Buff10.png",
                  @"S_Buff11.png",
                  @"S_Buff12.png",
                  @"S_Buff13.png",
                  @"S_Buff14.png",
                  @"S_Death01.png",
                  @"S_Death02.png",
                  @"S_Earth01.png",
                  @"S_Earth02.png",
                  @"S_Earth03.png",
                  @"S_Earth04.png",
                  @"S_Earth05.png",
                  @"S_Earth06.png",
                  @"S_Earth07.png",
                  @"S_Fire01.png",
                  @"S_Fire02.png",
                  @"S_Fire03.png",
                  @"S_Fire04.png",
                  @"S_Fire05.png",
                  @"S_Fire06.png",
                  @"S_Fire07.png",
                  @"S_Holy01.png",
                  @"S_Holy02.png",
                  @"S_Holy03.png",
                  @"S_Holy04.png",
                  @"S_Holy05.png",
                  @"S_Holy06.png",
                  @"S_Holy07.png",
                  @"S_Ice01.png",
                  @"S_Ice02.png",
                  @"S_Ice03.png",
                  @"S_Ice04.png",
                  @"S_Ice05.png",
                  @"S_Ice06.png",
                  @"S_Ice07.png",
                  @"S_Light01.png",
                  @"S_Light02.png",
                  @"S_Light03.png",
                  @"S_Magic01.png",
                  @"S_Magic02.png",
                  @"S_Magic03.png",
                  @"S_Magic04.png",
                  @"S_Physic01.png",
                  @"S_Physic02.png",
                  @"S_Poison01.png",
                  @"S_Poison02.png",
                  @"S_Poison03.png",
                  @"S_Poison04.png",
                  @"S_Poison05.png",
                  @"S_Poison06.png",
                  @"S_Poison07.png",
                  @"S_Shadow01.png",
                  @"S_Shadow02.png",
                  @"S_Shadow03.png",
                  @"S_Shadow04.png",
                  @"S_Shadow05.png",
                  @"S_Shadow06.png",
                  @"S_Shadow07.png",
                  @"S_Sword01.png",
                  @"S_Sword02.png",
                  @"S_Sword03.png",
                  @"S_Sword04.png",
                  @"S_Sword05.png",
                  @"S_Sword06.png",
                  @"S_Sword07.png",
                  @"S_Sword08.png",
                  @"S_Sword09.png",
                  @"S_Sword10.png",
                  @"S_Thunder01.png",
                  @"S_Thunder02.png",
                  @"S_Thunder03.png",
                  @"S_Thunder04.png",
                  @"S_Thunder05.png",
                  @"S_Thunder06.png",
                  @"S_Thunder07.png",
                  @"S_Water01.png",
                  @"S_Water02.png",
                  @"S_Water03.png",
                  @"S_Water04.png",
                  @"S_Water05.png",
                  @"S_Water06.png",
                  @"S_Water07.png",
                  @"S_Wind01.png",
                  @"S_Wind02.png",
                  @"S_Wind03.png",
                  @"S_Wind04.png",
                  @"S_Wind05.png",
                  @"S_Wind06.png",
                  @"S_Wind07.png",
                  @"W_Axe001.png",
                  @"W_Axe002.png",
                  @"W_Axe003.png",
                  @"W_Axe004.png",
                  @"W_Axe005.png",
                  @"W_Axe006.png",
                  @"W_Axe007.png",
                  @"W_Axe008.png",
                  @"W_Axe009.png",
                  @"W_Axe010.png",
                  @"W_Axe011.png",
                  @"W_Axe012.png",
                  @"W_Axe013.png",
                  @"W_Axe014.png",
                  @"W_Book01.png",
                  @"W_Book02.png",
                  @"W_Book03.png",
                  @"W_Book04.png",
                  @"W_Book05.png",
                  @"W_Book06.png",
                  @"W_Book07.png",
                  @"W_Bow01.png",
                  @"W_Bow02.png",
                  @"W_Bow03.png",
                  @"W_Bow04.png",
                  @"W_Bow05.png",
                  @"W_Bow06.png",
                  @"W_Bow07.png",
                  @"W_Bow08.png",
                  @"W_Bow09.png",
                  @"W_Bow10.png",
                  @"W_Bow11.png",
                  @"W_Bow12.png",
                  @"W_Bow13.png",
                  @"W_Bow14.png",
                  @"W_Dagger001.png",
                  @"W_Dagger002.png",
                  @"W_Dagger003.png",
                  @"W_Dagger004.png",
                  @"W_Dagger005.png",
                  @"W_Dagger006.png",
                  @"W_Dagger007.png",
                  @"W_Dagger008.png",
                  @"W_Dagger009.png",
                  @"W_Dagger010.png",
                  @"W_Dagger011.png",
                  @"W_Dagger012.png",
                  @"W_Dagger013.png",
                  @"W_Dagger014.png",
                  @"W_Dagger015.png",
                  @"W_Dagger016.png",
                  @"W_Dagger017.png",
                  @"W_Dagger018.png",
                  @"W_Dagger019.png",
                  @"W_Dagger020.png",
                  @"W_Dagger021.png",
                  @"W_Fist001.png",
                  @"W_Fist002.png",
                  @"W_Fist003.png",
                  @"W_Fist004.png",
                  @"W_Fist005.png",
                  @"W_Gun001.png",
                  @"W_Gun002.png",
                  @"W_Gun003.png",
                  @"W_Mace001.png",
                  @"W_Mace002.png",
                  @"W_Mace003.png",
                  @"W_Mace004.png",
                  @"W_Mace005.png",
                  @"W_Mace006.png",
                  @"W_Mace007.png",
                  @"W_Mace008.png",
                  @"W_Mace009.png",
                  @"W_Mace010.png",
                  @"W_Mace011.png",
                  @"W_Mace012.png",
                  @"W_Mace013.png",
                  @"W_Mace014.png",
                  @"W_Spear001.png",
                  @"W_Spear002.png",
                  @"W_Spear003.png",
                  @"W_Spear004.png",
                  @"W_Spear005.png",
                  @"W_Spear006.png",
                  @"W_Spear007.png",
                  @"W_Spear008.png",
                  @"W_Spear009.png",
                  @"W_Spear010.png",
                  @"W_Spear011.png",
                  @"W_Spear012.png",
                  @"W_Spear013.png",
                  @"W_Spear014.png",
                  @"W_Sword001.png",
                  @"W_Sword002.png",
                  @"W_Sword003.png",
                  @"W_Sword004.png",
                  @"W_Sword005.png",
                  @"W_Sword006.png",
                  @"W_Sword007.png",
                  @"W_Sword008.png",
                  @"W_Sword009.png",
                  @"W_Sword010.png",
                  @"W_Sword011.png",
                  @"W_Sword012.png",
                  @"W_Sword013.png",
                  @"W_Sword014.png",
                  @"W_Sword015.png",
                  @"W_Sword016.png",
                  @"W_Sword017.png",
                  @"W_Sword018.png",
                  @"W_Sword019.png",
                  @"W_Sword020.png",
                  @"W_Sword021.png",
                  @"W_Throw001.png",
                  @"W_Throw002.png",
                  @"W_Throw003.png",
                  @"W_Throw004.png",
                  @"W_Throw05.png",
                  @"arrow-down.png",
                  @"arrow-left.png",
                  @"arrow-right.png",
                  @"arrow-up.png",
                  @"help.png",
                  @"eye.png",
                  
                  nil];
    

}




@end