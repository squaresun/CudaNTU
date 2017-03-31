#include "lab1.h"
static const unsigned W = 640;
static const unsigned H = 960;
static const unsigned NFRAME = 7200;
static const unsigned LANE1START = 120;
static const unsigned LANE4END = 520;
static const unsigned LANEMID = 320;
static const unsigned NUMBEROFTIMEQUEUE = 6;
static const unsigned TIMEQUEUEMAXSIZE = 400;
static const unsigned NOTEYLENGTH = 12;
static const unsigned CRITICALLINEYBOTTOM = 55;	//bottom
static const unsigned CRITICALLINEYTOP = 70;	//top
static const unsigned CRITICALLINEXLEFT = 100;
static const unsigned CRITICALLINEXRIGHT = 540;

static const int LANE1NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {0,724,1241,1655,2379,2896,3310,4034,4551,4965,5689,6206,7655,9310,9827,10965,11689,12620,13137,13965,14793,15724,15931,17275,18103,19034,19241,20482,21310,22137,22965,23275,23482,23689,23896,24103,24310,24517,24724,25034,25241,25448,26482,26689,26896,27103,27310,28137,28551,28965,29379,29793,30206,30620,31034,31448,31862,32275,32689,33103,33517,33827,34344,34655,35068,35379,35689,36000,36413,36827,37137,37655,37862,38379,38689,39000,39310,39620,39827,40034,40551,40758,41379,41586,42103,42517,42724,43448,44172,45310,46344,47275,47896,48724,49137,49344,50068,50793,51931,52965,53172,53931,54620,54827,55344,55758,56689,57000,57517,57931,58137,59379,59689,60000,60413,60827,61655,61965,63103,63827,64241,64551,64965,65793,66413,66827,67862,68275,68689,69103,70137,74482,74896,75310,75724,76551,76689,76827,76965,77379,78310,78517,79551,79758,79965,80172,80793,81000,81931,82344,82862,83172,83586,84103,84517,84827,85241,85862,86482,87000,87827,88448,88965,89482,89793,90206,90413,91344,91758,92275,92689,93000,93310,93931,94448,94655,95172,95586,96931,97241,97551,97862,98172,98482,100448,100862,101275,101896,102310,102517,102931,103137,103655,103965,104275,104793,105103,105931,106862,107068,107793,108413};
static const int LANE2NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {413,1034,1448,1758,2068,2689,3000,3206,3724,4344,4758,5068,5379,6000,6310,6517,7344,7965,8379,8793,9620,10655,11275,12103,12931,13551,14379,15000,15413,16862,17689,18310,18724,19137,19344,19655,20275,21103,21931,22758,23172,23379,23586,23793,24000,24206,24413,24620,25655,25862,26068,26275,26965,27724,28448,28758,29172,29586,29896,30103,30413,30827,31137,31758,32068,32482,32896,33413,33620,34448,34965,35172,35482,35896,36206,36517,36724,37034,37344,37551,37965,38275,38482,38793,39206,39413,39827,40034,40551,40758,41482,41689,42103,42413,42827,43344,43655,44068,44275,45310,45620,46241,46655,46862,47068,47482,47793,48000,48137,48275,48724,49034,49448,49965,50275,50689,50896,51310,51448,51586,51931,52241,52862,53068,53275,53862,54137,54413,55034,55448,56172,56379,57103,57413,57827,58655,58758,59586,60310,60724,61241,61448,62275,62586,63413,63931,64344,64758,65172,66103,66413,66827,67448,67862,68172,68275,68586,68689,69000,69103,69413,69620,70034,70241,70551,70862,71172,72965,73344,73758,74068,74275,74482,74793,74896,75206,75310,75517,75724,76034,76241,77172,77586,78724,78931,79137,79344,79965,80172,80379,80586,80793,81000,81517,82034,82241,82551,82758,83068,83482,83689,84000,84206,84413,84724,85137,85344,85758,85965,86379,86586,87103,87413,87620,87931,88344,89068,89379,89689,89896,90310,90517,90827,91137,91655,92379,92896,93103,94344,94551,95482,95793,96103,96517,96724,97137,97344,97758,98068,98275,98689,99103,99413,99827,100034,100344,100551,100758,100965,101172,101793,103551,103758,104172,104379,104586,104896,105310,106137,106758,106965,107586,107862,108206};
static const int LANE3NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {827,1344,1862,2482,3103,4137,4655,5172,5793,6413,7137,7758,9000,9413,9724,10448,11068,11793,12310,12724,13034,13862,14689,15103,15517,16241,16448,17172,18000,18413,18827,19655,20068,20896,21724,22551,23172,23379,23586,23793,24000,24206,24413,24620,24931,25137,25344,25551,26586,26793,27034,27206,27724,28241,28551,29068,29275,29482,29689,30206,30517,30931,31241,31551,31862,32379,32586,32793,33000,33310,33724,34034,34241,34551,34862,35275,35793,36103,36310,36620,36931,37448,37758,38172,38586,39103,39517,39724,39931,40655,40862,42000,42310,42931,43241,43758,43965,44793,45000,45413,45724,46137,46551,46758,46965,47172,47689,48000,48137,48275,48620,48931,49551,49862,50379,50586,51310,51448,51586,52034,52344,52758,53068,53275,53793,54068,54413,55137,55862,56482,57310,57724,58655,58758,59689,60000,60310,60620,61241,61448,62068,62689,63000,63620,64034,64448,64758,65275,66000,66517,66724,66931,67448,68172,68586,69000,69310,69517,69724,69931,70344,70655,70965,71586,71896,72206,72551,72689,72827,73103,73241,73655,73965,74172,74379,74793,75206,75517,75931,76137,76344,76551,76689,76827,77068,77482,78206,78413,78620,78827,79862,80068,80275,80482,80689,80896,81103,81517,82137,82448,82655,82965,83379,83793,84310,84620,85034,85448,85655,86068,86275,86689,86896,87206,87517,88034,88241,88655,88862,89172,89586,90000,90724,90931,91241,91551,91965,92172,92482,92793,93413,94344,94551,95379,95689,96000,96206,96620,97034,97448,97655,98586,98793,99000,99206,99620,99931,100241,100655,101068,101379,101586,102000,102206,102620,102827,103241,103448,105517,106344,106758,106965,107655,107931,108206};
static const int LANE4NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {0,206,517,1137,1655,2172,2793,3310,3517,3827,4448,4965,5482,6103,6620,6827,7448,8068,8482,9103,9931,10137,10758,11379,12413,13448,14275,15206,15620,16137,16344,16758,17586,18517,18931,19862,20689,21517,22344,23275,23482,23689,23896,24103,24310,24517,24724,25758,25965,26172,26379,28344,28655,28862,29379,30000,30310,30724,31344,31655,31965,32172,32689,33206,33931,34137,34758,35172,35586,36000,36413,36827,37241,37655,38068,38482,38896,39310,39724,39931,40655,40862,42000,43034,43862,44379,44689,44896,45413,45827,46034,47379,47586,48620,49655,50482,51000,52034,52448,52655,52965,53172,54000,54620,54827,55551,56068,56275,56793,57206,57620,57931,58137,59379,59793,60103,60620,60827,61758,62379,62896,63310,63724,64137,64551,64965,65793,66517,66724,66931,71379,71689,72000,72310,72551,72689,72827,73103,73241,73551,77275,77689,79034,79241,79448,79655,79862,80068,80689,80896,81103,83275,83896,84931,85551,86172,86793,87310,87724,88137,88551,88758,89275,90103,90620,91034,91448,91862,92068,92586,93206,93931,94448,94655,95275,95896,96310,96827,97965,98379,98896,99310,99517,100137,101482,101689,102103,102413,102724,103034,103344,103862,104068,104482,104689,105000,105724,106551,106862,107068,107724,108413};
static const int LANE5NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {6620,7034,7448,7862,8275,8689,9103,9517,9931,10344,10758,11172,11586,12000,12413,12827,13448,13862,14275,14689,15103,15517,16137,16758,17172,17586,18000,18413,18827,19448,19862,20068,20275,20482,20689,20896,21103,21310,21517,21724,21931,22137,22344,22551,22758,22965,24827,27724,28862,30517,32172,33931,40137,40965,41793,42620,43034,43862,44482,44689,45517,46551,48413,49241,49655,50482,51103,51310,52137,53379,54206,56172,56379,58344,58448,58965,59068,59172,59275,60827,63103,63413,63724,65379,65482,65586,65689,66206,66620,67034,68068,68482,68896,69517,69724,69931,70655,70965,74689,75103,75517,76137,76344,76551,78206,81517,85241,85655,86068,86482,86896,87310,87724,88137,88551,90620,91034,91448,91862,93517,93655,93793,93931,94758,101379,103448,105103,105310,105517,105724,105931,106137,106344,106551,107172,108000,108413};
static const int LANE6NOTEONTIMEARR[TIMEQUEUEMAXSIZE] = {13241,13655,14068,14482,14896,15310,15724,16551,16965,17379,17793,18206,18620,19034,19862,20068,20275,20482,20689,20896,21103,21310,21517,21724,21931,22137,22344,22551,22758,22965,24827,27724,33103,35482,37137,38793,40137,40965,41379,42206,43448,44068,44586,45103,45931,46344,48000,48827,50068,50689,51206,51724,52551,53379,54206,55137,55551,55862,56482,56793,57103,58344,58448,58965,59068,59172,59275,60827,61758,62068,62379,62689,65379,65482,65586,65689,66206,67448,71172,71586,71689,71896,72000,72206,72310,72965,73758,74068,77793,79448,81517,81931,82344,82758,83172,83586,84000,84413,84827,88965,89379,89793,90206,92275,92689,93103,93517,93655,93793,93931,95172,96413,99724,101793,105103,105310,105517,105724,105931,106137,106344,106551,107172,108000,108413};

static const int CAMTIMEARR[TIMEQUEUEMAXSIZE] = {0, 19862, 24827, 27310, 27724, 27854, 38068, 40137, 40267, 40965, 41095, 53379, 53509, 54206, 54336, 57103, 60827, 61241, 64551, 67034, 67448, 67861, 71172, 71585, 74482, 74895, 77793, 78206, 81103, 81517, 81620, 93931, 94034, 94759, 95172, 95586, 96414, 105103, 105103, 106759, 107172, 107275, 108000, 108103, 108414, 108517, 999999};
static const float CAMROTATEARR[TIMEQUEUEMAXSIZE] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.3, 0.3, -0.3, -0.3, 0.3, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static const float CAMSCALEARR[TIMEQUEUEMAXSIZE] = {1, 1, 1.6, 0.8, 0.8, 1, 1, 0.9, 1.1, 1.1, 1.3, 1.3, 1.1, 1.1, 0.9, 0.8, 0.8, 1, 1, 1.3, 1.3, 1.3, 1.3, 1.3, 1.3, 1.3, 1.3, 0.8, 0.8, 1, 1.1, 1.1, 0.9, 0.9, 1.6, 1.6, 1.6, 1.6, 1.6, 1.1, 1.1, 0.9, 0.9, 1, 1, 1};
static const int CAMTRAPEZOIDFACTORARR[TIMEQUEUEMAXSIZE] = {0, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 300, 300, 300, 300, 300, 300, 300, 300, 0, 0, 0, 0, 0, 0, 0, 300, 300, 300, 300, 300, 0, 0, 0, 0, 0, 0, 0};

static const int LANE1NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,414,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,827,0,0,0,0,0,1242,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static const int LANE2NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1448,0,0,0,0,0,0,0,0,0,0,0,0,0};
static const int LANE3NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,620,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1448,0,0,0,0,0,0,0};
static const int LANE4NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,206,0,0,0,0,0,0,0,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,414,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,828,0,0,0,0,0,1242,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static const int LANE5NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,206,207,207,207,207,414,207,207,207,206,207,207,207,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2483,0,517,517,517,413,0,0,207,0,207,206,0,621,827,621,207,0,207,207,0,621,828,0,0,0,0,0,0,0,0,0,0,414,0,0,827,0,0,0,0,207,0,414,207,207,207,0,0,413,0,0,207,207,207,0,0,414,2897,0,0,0,0,0,0,0,0,0,414,0,0,0,413,0,0,0,0,414,414,1448,0,0,0,0,0,0,0,0,0,0,0};
static const int LANE6NOTEDURATIONTIMEARR[TIMEQUEUEMAXSIZE] = {0,0,0,0,207,207,413,0,0,0,0,207,207,621,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2483,0,414,518,518,517,0,0,621,828,207,207,0,207,0,207,620,828,207,207,0,207,0,0,0,0,0,0,0,0,828,0,0,0,0,0,0,414,0,0,0,0,0,0,0,0,207,0,207,0,0,0,0,0,0,0,0,414,413,1655,0,0,0,0,0,0,0,0,0,0,0,0,414,0,0,0,0,0,0,0,414,414,413,1448,0,0,0,0,0,0,0,0,0,0,0};

__device__ int noOfFrameOnDevice[1];
__device__ float fxDecayOnDevice[NUMBEROFTIMEQUEUE];
__device__ int timeQueueStartIndexArrOnDevice[NUMBEROFTIMEQUEUE];
__device__ float rotateAngleOnDevice[1];
__device__ float scaleFactorOnDevice[1];
__device__ int trapezoidFactorOnDevice[1];

template <typename T>
__host__ __device__
inline T lerp(T v0, T v1, T t) {
    return fma(t, v1, fma(-t, v0, v0));
}

struct NoteTimeQueue{
	int laneIndex;
	int endIndex;
	int noteOnTimeQueue[TIMEQUEUEMAXSIZE];
	int noteDurationTimeQueue[TIMEQUEUEMAXSIZE];
	__device__ bool isInsideNote(int y){
		for(int i = timeQueueStartIndexArrOnDevice[laneIndex];i<endIndex;i++){
			float delta = __int2float_rd(y) * expf(__int2float_rd(y)/__int2float_rd(W)) - __int2float_rd(noteOnTimeQueue[i] - __float2int_rd(__int2float_rd(noOfFrameOnDevice[0]) / 60.0 * 1000.0));
			if(delta > 0 and delta < __int2float_rd(noteDurationTimeQueue[i] > NOTEYLENGTH ? noteDurationTimeQueue[i] : NOTEYLENGTH)){
				return true;
			}
		}
		return false;
	}
};

struct Lab1VideoGenerator::Impl {
	int t = 0;
	float rotateAngle = 0.0;	//CCW
	float scaleFactor = 0.0;			//<1 : get bigger ; >1 : get smaller
	int trapezoidFactor = 0;
	int camIndex = 0;
	NoteTimeQueue timeQueues[NUMBEROFTIMEQUEUE];
	float fxDecay[NUMBEROFTIMEQUEUE];
	int timeQueueStartIndexArr[NUMBEROFTIMEQUEUE];
};

__device__ NoteTimeQueue timeQueuesOnDevice[NUMBEROFTIMEQUEUE];

Lab1VideoGenerator::Lab1VideoGenerator(): impl(new Impl) {
	//init all members
	for(int i = 0;i<NUMBEROFTIMEQUEUE;i++){
		impl->timeQueues[i].laneIndex = i;
		impl->timeQueues[i].endIndex = 0;
		impl->fxDecay[i] = 0;
		impl->timeQueueStartIndexArr[i] = 0;
	}

	memcpy(impl->timeQueues[0].noteOnTimeQueue, LANE1NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[1].noteOnTimeQueue, LANE2NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[2].noteOnTimeQueue, LANE3NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[3].noteOnTimeQueue, LANE4NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[4].noteOnTimeQueue, LANE5NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[5].noteOnTimeQueue, LANE6NOTEONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[0].noteDurationTimeQueue, LANE1NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[1].noteDurationTimeQueue, LANE2NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[2].noteDurationTimeQueue, LANE3NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[3].noteDurationTimeQueue, LANE4NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[4].noteDurationTimeQueue, LANE5NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);
	memcpy(impl->timeQueues[5].noteDurationTimeQueue, LANE6NOTEDURATIONTIMEARR, sizeof(int) * TIMEQUEUEMAXSIZE);

	//update end indices
	for(int i = 0;i<6;i++){
		int curEndIndex = 1;
		for(;impl->timeQueues[i].noteOnTimeQueue[curEndIndex] > 0;curEndIndex++);
		impl->timeQueues[i].endIndex = curEndIndex;
	}

	cudaMemcpyToSymbol(timeQueuesOnDevice, impl->timeQueues, sizeof(NoteTimeQueue) * NUMBEROFTIMEQUEUE);
}

Lab1VideoGenerator::~Lab1VideoGenerator() {}

void Lab1VideoGenerator::get_info(Lab1VideoInfo &info) {
	info.w = W;
	info.h = H;
	info.n_frame = NFRAME;
	// fps = 24/1 = 24
	info.fps_n = 60;
	info.fps_d = 1;
};

__device__ uint3 operator+(const uint3 &a, const uint3 &b){
	return make_uint3(a.x + b.x, a.y + b.y, a.z + b.z);
}

__device__ uint3 operator*(const float &a, const uint3 &b){
	return make_uint3(__float2uint_rd(__uint2float_rn(b.x) * a), __float2uint_rd(__uint2float_rn(b.y) * a), __float2uint_rd(__uint2float_rn(b.z) * a));
}

__device__ uint3 blendRGB(uint3 newRGB, uint3 oldRGB, float alpha){
	return alpha * newRGB + (1.0 - alpha) * oldRGB;
}

__device__ uint3 RGB2YUV(uint3 rgb){
	uint3 tmpYUV;
	tmpYUV.x = __float2uint_rd(0.299*__uint2float_rn(rgb.x) + 0.587*__uint2float_rn(rgb.y) + 0.114*__uint2float_rn(rgb.z));
	tmpYUV.y = __float2uint_rd(-0.169*__uint2float_rn(rgb.x) - 0.331*__uint2float_rn(rgb.y) + 0.5*__uint2float_rn(rgb.z) + 128.0);
	tmpYUV.z = __float2uint_rd(0.5*__uint2float_rn(rgb.x) - 0.419*__uint2float_rn(rgb.y) - 0.081*__uint2float_rn(rgb.z) + 128.0);
	return tmpYUV;
}

__global__ void Draw(uint8_t *yuv) {
	// TODO: draw more complex things here
	// Do not just submit the original file provided by the TA!
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	if (y < H and x < W) {
		//Set coordinate system to mid-point of screen
		const int realX = x;
		const int realY = y;

		int tmpX = x - W/2;
		int tmpY = y - H/2;

		//Scale
		tmpX = __float2int_rd(__int2float_rd(tmpX) * scaleFactorOnDevice[0]);
		//don't scale Y

		//Rotate
		x = __float2int_rd(__int2float_rd(tmpX) * cos(rotateAngleOnDevice[0]) - __int2float_rd(tmpY) * sin(rotateAngleOnDevice[0]));
		y = __float2int_rd(__int2float_rd(tmpY) * cos(rotateAngleOnDevice[0]) + __int2float_rd(tmpX) * sin(rotateAngleOnDevice[0]));

		//Reset coordinate system
		x += W/2;
		y += H/2;

		uint3 tmpRGB;
		tmpRGB.x = 0;
		tmpRGB.y = 0;
		tmpRGB.z = 0;
		float yProp = __int2float_rd(y + trapezoidFactorOnDevice[0])/__int2float_rd(H + trapezoidFactorOnDevice[0]);
		int3 xRange = make_int3(max(LANE1START, LANEMID - __float2int_rd(yProp * (LANEMID - LANE1START))), min(LANE4END, __float2uint_rd(yProp * (LANE4END - LANEMID) + LANEMID)), 0);
		xRange.z = xRange.y - xRange.x;
		
		if(x > CRITICALLINEXLEFT and x < CRITICALLINEXRIGHT and (H - y) > CRITICALLINEYBOTTOM and (H - y) < CRITICALLINEYTOP){
			tmpRGB.x = 243;
			tmpRGB.y = 253;
			tmpRGB.z = 155;
		}else if(y < H and x < W and y > H / 4 and (H - y) > CRITICALLINEYBOTTOM){
			if(x > xRange.x and x < xRange.y){
				//0: BT; 1: FX
				int2 locatedTimeQueueIndex = make_int2(min(3, __float2int_rd(__int2float_rd(x - xRange.x)/__int2float_rd(xRange.z) * 4.0)), min(5, __float2int_rd(__int2float_rd(x - xRange.x)/__int2float_rd(xRange.z)*2.0) + 4));
				//Fx Notes
				if(timeQueuesOnDevice[locatedTimeQueueIndex.y].isInsideNote(H - y - CRITICALLINEYTOP)){
					tmpRGB.x = 255;
					tmpRGB.y = 137;
					tmpRGB.z = 0;
				}
				//Bt Notes
				if(timeQueuesOnDevice[locatedTimeQueueIndex.x].isInsideNote(H - y - CRITICALLINEYTOP)){
					tmpRGB.x = 255;
					tmpRGB.y = 255;
					tmpRGB.z = 255;
				}
				//Press fx
				tmpRGB = blendRGB(make_uint3(255, 255, 0), tmpRGB, max(fxDecayOnDevice[locatedTimeQueueIndex.x], fxDecayOnDevice[locatedTimeQueueIndex.y]) * max(__int2float_rd(H / 5 - (H - y - CRITICALLINEYTOP)) / __int2float_rd(H/5), 0.0));
				//lane
				if((x - xRange.x) / (xRange.z / 4) < 3 and abs(((x - xRange.x) % (xRange.z / 4)) - (xRange.z / 4)) < 3){
					tmpRGB.x = 225;
					tmpRGB.y = 225;
					tmpRGB.z = 225;
				}
			}else if(x > xRange.x - 6 and x < xRange.x){
				tmpRGB.x = 0;
				tmpRGB.y = 162;
				tmpRGB.z = 255;
			}else if(x > xRange.y and x < xRange.y + 6){
				tmpRGB.x = 255;
				tmpRGB.y = 0;
				tmpRGB.z = 51;
			}
		}


		uint3 returnYUV = RGB2YUV(tmpRGB);
		yuv[realY*W+realX] = returnYUV.x;
		if(realX % 2 == 0 && realY % 2 == 0){
			yuv[W*H + realY*W/4 + realX/2] = returnYUV.y;
			yuv[W*H + W*H/4 + realY*W/4 + realX/2] = returnYUV.z;
		}

	}
}

void Lab1VideoGenerator::Generate(uint8_t *yuv) {
	int curMS = (int)((float)impl->t / 60.0 * 1000.0);
	//Refreshing the camera array index
	if(CAMTIMEARR[impl->camIndex + 1]  <= curMS){
		impl->camIndex++;
	}
	//Refreshing the rotate and scale factor
	impl->rotateAngle = lerp(CAMROTATEARR[impl->camIndex], CAMROTATEARR[impl->camIndex + 1], (float)(curMS - CAMTIMEARR[impl->camIndex]) / (float)(CAMTIMEARR[impl->camIndex + 1] - CAMTIMEARR[impl->camIndex]));
	impl->scaleFactor = lerp(CAMSCALEARR[impl->camIndex], CAMSCALEARR[impl->camIndex + 1], (float)(curMS - CAMTIMEARR[impl->camIndex]) / (float)(CAMTIMEARR[impl->camIndex + 1] - CAMTIMEARR[impl->camIndex]));
	impl->trapezoidFactor = (int)lerp((float)CAMTRAPEZOIDFACTORARR[impl->camIndex], (float)CAMTRAPEZOIDFACTORARR[impl->camIndex + 1], (float)(curMS - CAMTIMEARR[impl->camIndex]) / (float)(CAMTIMEARR[impl->camIndex + 1] - CAMTIMEARR[impl->camIndex]));

	cudaMemcpyToSymbol(noOfFrameOnDevice, &impl->t, sizeof(int));
	cudaMemcpyToSymbol(rotateAngleOnDevice, &impl->rotateAngle, sizeof(float));
	cudaMemcpyToSymbol(scaleFactorOnDevice, &impl->scaleFactor, sizeof(float));
	cudaMemcpyToSymbol(trapezoidFactorOnDevice, &impl->trapezoidFactor, sizeof(int));
	cudaMemcpyToSymbol(fxDecayOnDevice, impl->fxDecay, sizeof(float) * NUMBEROFTIMEQUEUE);
	cudaMemcpyToSymbol(timeQueueStartIndexArrOnDevice, impl->timeQueueStartIndexArr, sizeof(int) * NUMBEROFTIMEQUEUE);
	cudaMemset(yuv, 0, W*H);
	cudaMemset(yuv+W*H, 128, W*H/2);
	// if(impl->t == 100){
	Draw<<<dim3((W-1)/16+1,(H-1)/12+1), dim3(16,12)>>>(yuv);
	// }
	//Decay Fx
	for(int i = 0;i<NUMBEROFTIMEQUEUE;i++){
		impl->fxDecay[i] = max(impl->fxDecay[i] - 0.08, 0.0);
		if(impl->timeQueues[i].noteOnTimeQueue[impl->timeQueueStartIndexArr[i]] <= curMS){
			impl->fxDecay[i] = 1;
			if(impl->timeQueues[i].noteOnTimeQueue[impl->timeQueueStartIndexArr[i]] + impl->timeQueues[i].noteDurationTimeQueue[impl->timeQueueStartIndexArr[i]] <= curMS){
				impl->timeQueueStartIndexArr[i]++;
			}
		}
	}

	++(impl->t);
}
