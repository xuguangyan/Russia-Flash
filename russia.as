//---------------------------
//˵��:����˹����Դ��
//����:��ʥ 2007-7-27
//---------------------------

onClipEvent(load){
	//��ʼ��
	var intervalID; //�������ID
	var cur_type;  //��ǰ��������
	var cur_rotation;  //��ǰ����ת��
	var next_type; //��һ��������
	var next_rotation; //��һ����ת��
	var start_time; //��ʼ������
	var cur_scor;  //��ǰ����
	var cur_loop;  //ѭ����־
	var blGameOver; //������־
	var blPause;    //��ͣ��־
	var cur_x,cur_y; //��ǰ����x,y����(�Է���Ϊ��λ,�±��1,1��ʼ)
	var cur_direction; //��������
	var bgSound=new Sound(); //��������
	var keySound=new Sound(); //��������
	var eatSound=new Sound(); //��������
	var sound_pos;//��������ͷλ��
	var blSound_bk; //�Ƿ��б�������
	var blSound_key;//�Ƿ��а�����
	bgSound.attachSound("bgSound");
	keySound.attachSound("keySound");
	eatSound.attachSound("eatSound");
	
	//�������з�����״,��������ά����bricks[][][]
	var bricks=new Array(4*7);
	for(var i=0;i<4*7;i++){
		bricks[i]=new Array(4);
		for(var j=0;j<4;j++)
			bricks[i][j]=new Array(4);
	}
    bricks=[
			/*������η���*/
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
		
			/*��һ�����η���*/
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
		
			/*��L���η���*/
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
		
			/*����L���η���*/
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
		
			/*��Z���η���*/
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
		
			/*����Z���η���*/
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
		
			/*��T���η���*/
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
	
	//������Ϸ
	reset();
	
	//�ж��Ƿ񷽿���box
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
	//�Ƿ�ɻ��Ʒ���
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
	//�Ƿ��������
	function isFullBrick(y){
		if(y<3)
			return true;
		else
			return false;
	}
	//���Ʒ���
	function paintBrick(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,100);
				}
			}
	}
	//��������
	function eraseBrick(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,0);
				}
			}
	}
	//��������2
	function eraseBrick2(y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
					var num=getNum(y+i,x+j);
					setProperty("_root.box"+num,_alpha,0);
			}
	}
	//����next����
	function paintBrickn(arr,y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
				if(arr[i][j]){
					var num=getNum(y+i,x+j);
					setProperty("_root.boxn"+num,_alpha,100);
				}
			}
	}
	//����next����
	function eraseBrickn(y,x){
		for(var i=0;i<4;i++)
			for(var j=0;j<4;j++){
					var num=getNum(y+i,x+j);
					setProperty("_root.boxn"+num,_alpha,0);
			}
	}
	//����next����
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
	//ͨ�������ȡ��Ӧboxʵ��������
	function getNum(row,col){
		return (row-1)*11+col;
	}
	//�������䷽��
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
	//�ж�����
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
				cur_score+=line*10+10; //������10��
				break;
			case 4:
				cur_score+=line*10+20; //������20��
				break;
		}
		if(line>0){
			_root.score.text=cur_score;
			if(blSound_key)
				eatSound.start();
		}
	}
	//����
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
	//����ȫ��box
	function setAllHide(){
		for(var i=1;i<=176;i++)
		{
			setProperty("_root.box"+i,_alpha,"0");
		}
	}
	//��ʾȫ��box
	function setAllShow(){
		for(var i=1;i<=176;i++)
		{
			setProperty("_root.box"+i,_alpha,"100");
		}
	}
	//��ʾ����box(������Ļ���)
	function setSomeShow(arr){
		for(var i=0;i<arr.length;i++)
		{
			setProperty("_root.box"+arr[i],_alpha,"100");
		}
	}
	//��Ϸ����
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
	//������Ϸ
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
	//����
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
	//��ͣ
	_root.mcPause.onRelease=function(){
		if(!blGameOver){
			myColor=new Color(_root.mcPause.table);
			if(_root.mcPause.table.text=="����ͣ��"){
				myColor.setRGB(0x999999);
				_root.mcPause.table.text="�翪ʼ��";
				blPause=true;
				clearInterval(intervalID);
				sound_pos=bgSound.position;
				if(blSound_bg){
					bgSound.stop();
				}
			}
			else{
				myColor.setRGB(0x006699);
				_root.mcPause.table.text="����ͣ��";
				blPause=false;
				intervalID=setInterval(directionBrick,200);
				if(blSound_bg){
					bgSound.start(sound_pos/1000,100);
				}
			}
		}
	}
	//��������
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
	//��������
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
//��������
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
//��������
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
//�������
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
//��������
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
//��ͣ��Ϸ
on(keyPress "<Space>"){
	if(!blGameOver)
	_root.mcPause.onRelease();
}
//��������
on(keyPress "<Insert>"){
	_root.mcTable.onRelease();
}
//������Ϸ
on(keyPress "<Home>"){
	if(blGameOver)
	_root.reset.onRelease();
}
//��������
on(keyPress "<End>"){
	_root.mcSound.onRelease();
}
//���ؼ���
on(keyPress "<PageDown>"){
	_root.mcKey.onRelease();
}