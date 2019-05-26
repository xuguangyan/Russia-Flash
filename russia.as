//---------------------------
//说明:俄罗斯方块源码
//作者:大圣 2007-7-27
//---------------------------

onClipEvent(load){
	//初始化
	var intervalID; //间隔函数ID
	var cur_type;  //当前方块类型
	var cur_rotation;  //当前方块转角
	var next_type; //下一方块类型
	var next_rotation; //下一方块转角
	var start_time; //开始毫秒数
	var cur_scor;  //当前分数
	var cur_loop;  //循环标志
	var blGameOver; //结束标志
	var blPause;    //暂停标志
	var cur_x,cur_y; //当前方块x,y坐标(以方格为单位,下标从1,1开始)
	var cur_direction; //按键方向
	var bgSound=new Sound(); //背景音乐
	var keySound=new Sound(); //按键声音
	var eatSound=new Sound(); //消行声音
	var sound_pos;//声音播放头位置
	var blSound_bk; //是否有背景音乐
	var blSound_key;//是否有按键音
	bgSound.attachSound("bgSound");
	keySound.attachSound("keySound");
	eatSound.attachSound("eatSound");
	
	//定义所有方块形状,并存于三维数组bricks[][][]
	var bricks=new Array(4*7);
	for(var i=0;i<4*7;i++){
		bricks[i]=new Array(4);
		for(var j=0;j<4;j++)
			bricks[i][j]=new Array(4);
	}
    bricks=[
			/*“田”字形方块*/
		   [[1,1,0,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
			/*“一”字形方块*/
		   [[1,1,1,1],
			[0,0,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[0,1,0,0],
			[0,1,0,0],
			[0,1,0,0],
			[0,1,0,0]],
		
		   [[1,1,1,1],
			[0,0,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[0,1,0,0],
			[0,1,0,0],
			[0,1,0,0],
			[0,1,0,0]],
		
			/*“L”形方块*/
		   [[1,0,0,0],
			[1,0,0,0],
			[1,1,0,0],
			[0,0,0,0]],
		
		   [[1,1,1,0],
			[1,0,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[0,1,0,0],
			[0,1,0,0],
			[0,0,0,0]],
		
		   [[0,0,1,0],
			[1,1,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
			/*反“L”形方块*/
		   [[0,1,0,0],
			[0,1,0,0],
			[1,1,0,0],
			[0,0,0,0]],
		
		   [[1,0,0,0],
			[1,1,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[1,0,0,0],
			[1,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,1,0],
			[0,0,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
			/*“Z”形方块*/
		   [[1,1,0,0],
			[0,1,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[0,1,0,0],
			[1,1,0,0],
			[1,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,0,0],
			[0,1,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[0,1,0,0],
			[1,1,0,0],
			[1,0,0,0],
			[0,0,0,0]],
		
			/*反“Z”形方块*/
		   [[0,1,1,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,0,0,0],
			[1,1,0,0],
			[0,1,0,0],
			[0,0,0,0]],
		
		   [[0,1,1,0],
			[1,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,0,0,0],
			[1,1,0,0],
			[0,1,0,0],
			[0,0,0,0]],
		
			/*“T”形方块*/
		   [[0,1,0,0],
			[1,1,1,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[1,0,0,0],
			[1,1,0,0],
			[1,0,0,0],
			[0,0,0,0]],
		
		   [[1,1,1,0],
			[0,1,0,0],
			[0,0,0,0],
			[0,0,0,0]],
		
		   [[0,1,0,0],
			[1,1,0,0],
			[0,1,0,0],
			[0,0,0,0]]
  		 ];
	
	//重设游戏
	reset();
	
	//判断是否方块内box
	function isInBrick(arr,y,x,n){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					if(n==num) return true;
				}
			}
		return false;
	}
	//是否可绘制方块
	function paintEnable(arr,y,x,pre_arr,pre_y,pre_x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					if(y+i<1||y+i>16||x+j<1||x+j>11){
						return false;
					}
					else{
						var num=getNum(y+i,x+j);
						if(eval("_root.box"+num)._alpha==100&&!isInBrick(pre_arr,pre_y,pre_x,num)){
							return false;
						}
					}
				}
			}
		return true;
	}
	//是否溢出方块
	function isFullBrick(y){
		if(y<3)
			return true;
		else
			return false;
	}
	//绘制方块
	function paintBrick(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,100);
				}
			}
	}
	//擦除方块
	function eraseBrick(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,0);
				}
			}
	}
	//擦除方块2
	function eraseBrick2(y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,0);
			}
	}
	//绘制next方块
	function paintBrickn(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.boxn"+num,_alpha,100);
				}
			}
	}
	//擦除next方块
	function eraseBrickn(y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
					var num=getNum(y+i,x+j);
					setProperty("_root.boxn"+num,_alpha,0);
			}
	}
	//产生next方块
	function createBrickn(){
		cur_type=next_type;
		cur_rotation=next_rotation;
		next_type=Math.floor(Math.random()*7);
		next_rotation=Math.floor(Math.random()*4);
		eraseBrickn(1,5);
		paintBrickn(bricks[next_type*4+next_rotation],1,5);
		eraseBrick2(1,5);
		paintBrick(bricks[cur_type*4+cur_rotation],1,5);
		cur_x=5;cur_y=1;
	}
	//通过坐标获取对应box实例的索引
	function getNum(row,col){
		return (row-1)*11+col;
	}
	//控制下落方块
	function directionBrick(){
		if(!cur_loop)
		{
			cur_loop=true;
			now=new Date();
			start_time=now.getTime();
			if(blSound_bg){
				bgSound.start(sound_pos/1000,100);
			}
		}
		switch(cur_direction){
			case 1:
			{
				var arr=bricks[cur_type*4+cur_rotation];
				if(paintEnable(arr,cur_y,cur_x-1,arr,cur_y,cur_x)){
					eraseBrick(arr,cur_y,cur_x);
					paintBrick(arr,cur_y,--cur_x);
				}
				break;
			}
			case 2:
			{
				var arr=bricks[cur_type*4+cur_rotation];
				if(paintEnable(arr,cur_y,cur_x+1,arr,cur_y,cur_x)){
					eraseBrick(arr,cur_y,cur_x);
					paintBrick(arr,cur_y,++cur_x);
				}
				break;
			}
			case 3:
			{
				var r=(cur_rotation+1)%4;
				var arr=bricks[cur_type*4+cur_rotation];
				var arr2=bricks[cur_type*4+r];
				if(paintEnable(arr2,cur_y,cur_x,arr,cur_y,cur_x)){
					eraseBrick(arr,cur_y,cur_x);
					cur_rotation++;
					cur_rotation=cur_rotation%4;
					arr=bricks[cur_type*4+cur_rotation];
					paintBrick(arr,cur_y,cur_x);
				}
				break;
			}
			case 4:
			{
				var arr=bricks[cur_type*4+cur_rotation];
				if(paintEnable(arr,cur_y+1,cur_x,arr,cur_y,cur_x)){
					eraseBrick(arr,cur_y,cur_x);
					paintBrick(arr,++cur_y,cur_x);
				}
				else{
					chkEatLine();
					if(isFullBrick(cur_y))
						gameOver();
					else
						createBrickn();
				}
				break;
			}
		}
		cur_direction=4;
		now=new Date();
		_root.usetime.text=Math.round((now.getTime()-start_time)/1000);
	}
	//判断消行
	function chkEatLine(){
		var line=0;
		for(var i=3;i<=16;i++){
			flag=true;
			for(var j=1;j<=11;j++){
				var num=getNum(i,j);
				if(eval("_root.box"+num)._alpha==0){
					flag=false;
					break;
				}
			}
			if(flag){
				eatLine(i);
				line++;
			}
		}
		switch(line){
			case 1:
			case 2:
				cur_score+=line*10;
				break;
			case 3:
				cur_score+=line*10+10; //消三行10分
				break;
			case 4:
				cur_score+=line*10+20; //消三行20分
				break;
		}
		if(line>0){
			_root.score.text=cur_score;
			if(blSound_key)
				eatSound.start();
		}
	}
	//消行
	function eatLine(n){
		for(var i=n*11-10;i<=n*11;i++)
		{
			setProperty("_root.box"+i,_alpha,0);
		}
		for(var i=n-1;i>=1;i--){
			for(var j=i*11-10;j<=i*11;j++)
			if(eval("_root.box"+j)._alpha==100){
				setProperty("_root.box"+j,_alpha,0);
				k=j+11;
				setProperty("_root.box"+k,_alpha,100);
			}
		}
	}
	//隐藏全部box
	function setAllHide(){
		for(var i=1;i<=176;i++)
		{
			setProperty("_root.box"+i,_alpha,"0");
		}
	}
	//显示全部box
	function setAllShow(){
		for(var i=1;i<=176;i++)
		{
			setProperty("_root.box"+i,_alpha,"100");
		}
	}
	//显示部分box(用于屏幕输出)
	function setSomeShow(arr){
		for(var i=0;i<arr.length;i++)
		{
			setProperty("_root.box"+arr[i],_alpha,"100");
		}
	}
	//游戏结束
	function gameOver(){
		setAllHide();
		if(cur_loop){
			clearInterval(intervalID);
			cur_loop=false;
			blGameOver=true;
			setProperty(_root.reset,_alpha,100);
		}
		if(blSound_bg){
			bgSound.stop();
			blSound_bg=false;
		}
	}
	//重设游戏
	function reset(){
		blGameOver=false;
		blPause=false
		cur_score=0;
		cur_loop=false;
		cur_x=5;cur_y=1;
		cur_direction=4;
		sound_pos=0;
		blSound_bg=true;
		blSound_key=true;
		setAllHide();
		createBrickn();
		createBrickn();
		_root.score.text="0";
		_root.usetime.text="0";
		setProperty(_root.reset,_alpha,0);
	}
	_root.reset.onRelease=reset;
	//网格
	_root.mcTable.onRelease=function(){
		myColor=new Color(_root.mcTable.table);
		if(_root.table._alpha==100){
			_root.table._alpha=0;
			myColor.setRGB(0x999999);
		}
		else{
			_root.table._alpha=100;
			myColor.setRGB(0x006699);
		}
	}
	//暂停
	_root.mcPause.onRelease=function(){
		if(!blGameOver){
			myColor=new Color(_root.mcPause.table);
			if(_root.mcPause.table.text=="╃暂停╄"){
				myColor.setRGB(0x999999);
				_root.mcPause.table.text="╃开始╄";
				blPause=true;
				clearInterval(intervalID);
				sound_pos=bgSound.position;
				if(blSound_bg){
					bgSound.stop();
				}
			}
			else{
				myColor.setRGB(0x006699);
				_root.mcPause.table.text="╃暂停╄";
				blPause=false;
				intervalID=setInterval(directionBrick,200);
				if(blSound_bg){
					bgSound.start(sound_pos/1000,100);
				}
			}
		}
	}
	//背景音乐
	_root.mcSound.onRelease=function(){
		if(!blGameOver&&!blPause){
			myColor=new Color(_root.mcSound.table);
			if(blSound_bg){
				bgSound.stop();
				blSound_bg=false;
				myColor.setRGB(0x999999);
			}
			else{
				bgSound.start(sound_pos/1000,100);
				blSound_bg=true;
				_root.table._alpha=100;
				myColor.setRGB(0x006699);
			}
		}		
	}
	//按键声音
	_root.mcKey.onRelease=function(){
		if(!blGameOver&&!blPause){
			myColor=new Color(_root.mcKey.table);
			if(blSound_key){
				blSound_key=false;
				myColor.setRGB(0x999999);
			}
			else{
				blSound_key=true;
				_root.table._alpha=100;
				myColor.setRGB(0x006699);
			}
		}		
	}
}
//方块左移
on(keyPress "<Left>"){
	if(!blGameOver&&!blPause){
		cur_direction=1;
		if(!cur_loop){
			intervalID=setInterval(directionBrick,200);
		}
		else
		{
			if(blSound_key)
				keySound.start();
			directionBrick();
		}
	}
}
//方块右移
on(keyPress "<Right>"){
	if(!blGameOver&&!blPause){
		cur_direction=2;
		if(!cur_loop){
			intervalID=setInterval(directionBrick,200);
		}
		else
		{
			if(blSound_key)
				keySound.start();
			directionBrick();
		}
	}
}
//方块变形
on(keyPress "<Up>"){
	if(!blGameOver&&!blPause){
		cur_direction=3;
		if(!cur_loop){
			intervalID=setInterval(directionBrick,200);
		}
		else
		{
			if(blSound_key)
				keySound.start();
			directionBrick();
		}
	}
}
//方块下移
on(keyPress "<Down>"){
	if(!blGameOver&&!blPause){
		cur_direction=4;
		if(!cur_loop){
			intervalID=setInterval(directionBrick,200);
		}
		else
		{
			if(blSound_key)
				keySound.start();
			directionBrick();
		}
	}
}
//暂停游戏
on(keyPress "<Space>"){
	if(!blGameOver)
	_root.mcPause.onRelease();
}
//隐显网格
on(keyPress "<Insert>"){
	_root.mcTable.onRelease();
}
//重新游戏
on(keyPress "<Home>"){
	if(blGameOver)
	_root.reset.onRelease();
}
//开关音乐
on(keyPress "<End>"){
	_root.mcSound.onRelease();
}
//开关键音
on(keyPress "<PageDown>"){
	_root.mcKey.onRelease();
}