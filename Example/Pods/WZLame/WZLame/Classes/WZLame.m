//
//  WZLame.m
//  WZLame
//
//  Created by qiuqixiang on 2020/9/11.
//

#import "WZLame.h"
#import <lame/lame.h>
@implementation WZLame

+(void)conventToMp3:(NSString *)sourcePath withFilePath:(NSString *)mp3FilePath withStop:(BOOL)isStop{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            
            int read, write;
            
            FILE *pcm = fopen([sourcePath cStringUsingEncoding:NSASCIIStringEncoding], "rb");
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE * 2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 44100.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            long curpos;
            BOOL isSkipPCMHeader = NO;
            
            do {
                
                curpos = ftell(pcm);
                
                long startPos = ftell(pcm);
                
                fseek(pcm, 0, SEEK_END);
                long endPos = ftell(pcm);
                
                long length = endPos - startPos;
                
                fseek(pcm, curpos, SEEK_SET);
                
                
                if (length > PCM_SIZE * 2 * sizeof(short int)) {
                    
                    if (!isSkipPCMHeader) {
                        //Uump audio file header, If you do not skip file header
                        //you will heard some noise at the beginning!!!
                        fseek(pcm, 4 * 1024, SEEK_SET);
                        isSkipPCMHeader = YES;
                    }
                    
                    read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                    fwrite(mp3_buffer, write, 1, mp3);
                }
                
                else {
                    [NSThread sleepForTimeInterval:0.05];
                }
                
            } while (!isStop);
            
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            NSLog(@"转码失败");
        }
        @finally {
            NSLog(@"转码成功");
        }
    });
}

@end
