// SpeechUtteranceViewController.m
//
// Copyright (c) 2014 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SpeechUtteranceViewController.h"

@import AVFoundation;

static NSString * BCP47LanguageCodeFromISO681LanguageCode(NSString *ISO681LanguageCode) {
    if ([ISO681LanguageCode isEqualToString:@"ar"]) {
        return @"ar-SA";
    } else if ([ISO681LanguageCode hasPrefix:@"cs"]) {
        return @"cs-CZ";
    } else if ([ISO681LanguageCode hasPrefix:@"da"]) {
        return @"da-DK";
    } else if ([ISO681LanguageCode hasPrefix:@"de"]) {
        return @"de-DE";
    } else if ([ISO681LanguageCode hasPrefix:@"el"]) {
        return @"el-GR";
    } else if ([ISO681LanguageCode hasPrefix:@"en"]) {
        return @"en-US"; // en-AU, en-GB, en-IE, en-ZA
    } else if ([ISO681LanguageCode hasPrefix:@"es"]) {
        return @"es-ES"; // es-MX
    } else if ([ISO681LanguageCode hasPrefix:@"fi"]) {
        return @"fi-FI";
    } else if ([ISO681LanguageCode hasPrefix:@"fr"]) {
        return @"fr-FR"; // fr-CA
    } else if ([ISO681LanguageCode hasPrefix:@"hi"]) {
        return @"hi-IN";
    } else if ([ISO681LanguageCode hasPrefix:@"hu"]) {
        return @"hu-HU";
    } else if ([ISO681LanguageCode hasPrefix:@"id"]) {
        return @"id-ID";
    } else if ([ISO681LanguageCode hasPrefix:@"it"]) {
        return @"it-IT";
    } else if ([ISO681LanguageCode hasPrefix:@"ja"]) {
        return @"ja-JP";
    } else if ([ISO681LanguageCode hasPrefix:@"ko"]) {
        return @"ko-KR";
    } else if ([ISO681LanguageCode hasPrefix:@"nl"]) {
        return @"nl-NL"; // nl-BE
    } else if ([ISO681LanguageCode hasPrefix:@"no"]) {
        return @"no-NO";
    } else if ([ISO681LanguageCode hasPrefix:@"pl"]) {
        return @"pl-PL";
    } else if ([ISO681LanguageCode hasPrefix:@"pt"]) {
        return @"pt-BR"; // pt-PT
    } else if ([ISO681LanguageCode hasPrefix:@"ro"]) {
        return @"ro-RO";
    } else if ([ISO681LanguageCode hasPrefix:@"ru"]) {
        return @"ru-RU";
    } else if ([ISO681LanguageCode hasPrefix:@"sk"]) {
        return @"sk-SK";
    } else if ([ISO681LanguageCode hasPrefix:@"sv"]) {
        return @"sv-SE";
    } else if ([ISO681LanguageCode hasPrefix:@"th"]) {
        return @"th-TH";
    } else if ([ISO681LanguageCode hasPrefix:@"tr"]) {
        return @"tr-TR";
    } else if ([ISO681LanguageCode hasPrefix:@"zh"]) {
        return @"zh-CN"; // zh-HK, zh-TW
    } else {
        return nil;
    }
}

typedef NS_ENUM(NSInteger, SpeechUtteranceLanguage) {
    Arabic,
    Chinese,
    Czech,
    Danish,
    Dutch,
    German,
    Greek,
    English,
    Finnish,
    French,
    Hindi,
    Hungarian,
    Indonesian,
    Italian,
    Japanese,
    Korean,
    Norwegian,
    Polish,
    Portuguese,
    Romanian,
    Russian,
    Slovak,
    Spanish,
    Swedish,
    Thai,
    Turkish,
};

NSString * const SpeechUtterancesByLanguage[] = {
    [Arabic]        = @"لَيْسَ حَيَّاً مَنْ لَا يَحْلُمْ",
    [Chinese]       = @"风向转变时、\n有人筑墙、\n有人造风车",
    [Czech]         = @"Kolik jazyků znáš, tolikrát jsi člověkem.",
    [Danish]        = @"Enhver er sin egen lykkes smed.",
    [Dutch]         = @"Wie zijn eigen tuintje wiedt, ziet het onkruid van een ander niet.",
    [German]        = @"Die beste Bildung findet ein gescheiter Mensch auf Reisen.",
    [Greek]         = @"Ἐν οἴνῳ ἀλήθεια",
    [English]       = @"All the world's a stage, and all the men and women merely players.",
    [Finnish]       = @"On vähäkin tyhjää parempi.",
    [French]        = @"Le plus grand faible des hommes, c'est l'amour qu'ils ont de la vie.",
    [Hindi]         = @"जान है तो जहान है",
    [Hungarian]     = @"Ki korán kel, aranyat lel|Aki korán kel, aranyat lel.",
    [Indonesian]    = @"Jadilah kumbang, hidup sekali di taman bunga, jangan jadi lalat, hidup sekali di bukit sampah.",
    [Italian]       = @"Finché c'è vita c'è speranza.",
    [Japanese]      = @"天に星、地に花、人に愛",
    [Korean]        = @"손바닥으로 하늘을 가리려한다",
    [Norwegian]     = @"D'er mange ǿksarhogg, som eiki skal fella.",
    [Polish]        = @"Co lekko przyszło, lekko pójdzie.",
    [Portuguese]    = @"É de pequenino que se torce o pepino.",
    [Romanian]      = @"Cine se scoală de dimineață, departe ajunge.",
    [Russian]       = @"Челове́к рожда́ется жить, а не гото́виться к жи́зни.",
    [Slovak]        = @"Každy je sám svôjho št'astia kováč.",
    [Spanish]       = @"La vida no es la que uno vivió, sino la que uno recuerda, y cómo la recuerda para contarla.",
    [Swedish]       = @"Verkligheten överträffar dikten.",
    [Thai]          = @"ความลับไม่มีในโลก",
    [Turkish]       = @"Al elmaya taş atan çok olur."
};

static NSString * BCP47LanguageCodeForString(NSString *string) {
    NSString *ISO681LanguageCode = (__bridge NSString *)CFStringTokenizerCopyBestStringLanguage((__bridge CFStringRef)string, CFRangeMake(0, [string length]));
    return BCP47LanguageCodeFromISO681LanguageCode(ISO681LanguageCode);
}

#pragma mark -

@interface SpeechUtteranceViewController () <AVSpeechSynthesizerDelegate>
@property (readwrite, nonatomic, copy) NSString *utteranceString;
@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@end

@implementation SpeechUtteranceViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //設定語言
    //SpeechUtteranceLanguage randomLanguage = arc4random_uniform(25);
    //self.utteranceString = SpeechUtterancesByLanguage[randomLanguage];
    
    //初始化
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;

}

-(IBAction)speak
{
    //選擇要念的文字
    
    if (self.inputTextField.text.length == 0) {
        self.utteranceString = SpeechUtterancesByLanguage[Chinese];
    }
    else {
        self.utteranceString = self.inputTextField.text;
    }
    
    //設定顯示文字
    self.utteranceLabel.attributedText =
    [[NSAttributedString alloc] initWithString:self.utteranceString];
    
    //將所選文字翻譯
    NSMutableString *mutableString = [self.utteranceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
    self.transliterationLabel.text = mutableString;
    
    
    //判斷
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.utteranceString];
    NSLog(@"BCP-47 Language Code: %@", BCP47LanguageCodeForString(utterance.speechString));
    self.lanLabel.text = BCP47LanguageCodeForString(utterance.speechString);
    
    //設定聲音物件
//    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:BCP47LanguageCodeForString(utterance.speechString)];
    //utterance.pitchMultiplier = 0.5f;
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    [self.speechSynthesizer speakUtterance:utterance];
}

- (void)speakWord:(NSString *)word
{
    //選擇要念的文字
    
    //因為沒有View所以沒過viewDidLoad
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;
    
    if (word.length == 0) {
        self.utteranceString = SpeechUtterancesByLanguage[Chinese];
    }
    else {
        self.utteranceString = word;
    }
    
    //設定顯示文字
    self.utteranceLabel.attributedText =
    [[NSAttributedString alloc] initWithString:self.utteranceString];
    
    //將所選文字翻譯
    NSMutableString *mutableString = [self.utteranceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
    self.transliterationLabel.text = mutableString;
    
    
    //判斷
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.utteranceString];
    NSLog(@"BCP-47 Language Code: %@", BCP47LanguageCodeForString(utterance.speechString));
    self.lanLabel.text = BCP47LanguageCodeForString(utterance.speechString);
    
    //設定聲音物件
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:BCP47LanguageCodeForString(utterance.speechString)];
//    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"apple"];

    //utterance.pitchMultiplier = 0.5f;
    utterance.rate = 0.55;
    utterance.preUtteranceDelay = 0.1f;
    utterance.postUtteranceDelay = 0.1f;
    
    [self.speechSynthesizer speakUtterance:utterance];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
willSpeakRangeOfSpeechString:(NSRange)characterRange
                utterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.utteranceString];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
    self.utteranceLabel.attributedText = mutableAttributedString;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
  didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));

    self.utteranceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));

    self.utteranceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.utteranceString];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
