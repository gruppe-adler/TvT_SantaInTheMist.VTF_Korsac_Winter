class Params {
    class WeatherSetting {
        title = "Weather";
        values[] = {-1,0,25,50,75,100};
        texts[] = {"Random","Clear","Cloudy","Overcast","Rainy","Stormy"};
        default = -1;
    };

    class TimeOfDay {
        title = "Time of Day";
        values[] = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
        texts[] = {"Random","00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00 (Sunrise)","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00 (Sunset)","19:00","20:00","21:00","22:00","23:00"};
        default = 12;
    };

    class CourierHeadStart {
        title = "Courier Head Start Time (Minutes)";
        values[] = {10,60,120,180,240,300,360,420,480,540,600};
        texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
        default = 60;
    };

    class AreaSize {
        title = "Play Area Size";
        values[] = {5,8,10,15,20};
        texts[] = {"tiny","small","normal","big","huge"};
        default = 10;
    };

    class Civilians {
        title = "Ambient Civilians";
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
    };

    class RankedMode
    {
        title = "Track Winrates";
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 1;
    };

    class DebugMode {
        title = "Debug Mode";
        values[] = {0,1};
        texts[] = {"Off","On"};
        default = 0;
    };
};