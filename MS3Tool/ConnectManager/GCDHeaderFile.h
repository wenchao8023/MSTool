

//online 1 local 0
#define DEV_STATE_ONLINE 1

// 连接超时时长
static const int TIMEOUT = 1;

#define UPLOAD_ENV_ONLINE @"online"

#define UPLOAD_ENV_LOCAL @"local"

#define PROTOCOL_VERSION 1


/**
 *  AP config
 */

// 连接音箱WiFi时的 host和 port
#if DEV_STATE_ONLINE

static NSString *TCP_HOST = @"192.168.8.8"; //socket
static const uint16_t TCP_PORT = 2016;
#else

static NSString *TCP_HOST = @"192.168.8.8"; //socket
static const uint16_t TCP_PORT = 2016;
#endif

// TCP重连次数
static const NSInteger TCPConnectLimit = 3;


/**
 *  STA config
 */

static const NSInteger UDPSendDataLimit = 6;     // UDP重连次数

static const int DELAYTIME = 15;    // AP模式结束之后休眠时长

static const uint16_t UDP_PORT_S = 7778;    // 服务器端端口号
static const uint16_t UDP_PORT_C = 1014;    // 客户端端口号
static const uint16_t UDP_PORT_R = 1015;    // 
static const uint16_t UDP_PORT_G = 10000;   // 广播组端口
static NSString *UDP_HOST_C = @"255.255.255.255";

