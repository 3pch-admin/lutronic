var xhr = {};
//ajax.xhr = {}; //ajax.xhr ��Ű�� ����

xhr.Request = function(url, params, callback, method){		//Request Ŭ������ ������ ��ü ������ ���ÿ� send() �Լ� ȣ��
	this.url = url;
	this.params = params;
	this.callback = callback;
	this.method = method;
	this.send();
}

xhr.Request.prototype = {
	getXMLHttpRequest : function(){
		if(window.ActiveXObject){
			try{
				return new ActiveXObject("Msxml2.XMLHTTP");
			}catch(e){
				try{
					return new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e1){return null;}
			}
		}else if(window.XMLHttpRequest){
			return new XMLHttpRequest();
		}else{
			return null;
		}
	},send : function(){
		this.req = this.getXMLHttpRequest();	//req ������Ƽ�� XMLHttpRequest ��ü�� ����
		
		var httpMethod = this.method ? this.method : 'GET';
		if(httpMethod != 'GET' && httpMethod != 'POST'){
			httpMethod = 'GET';
		}
		var httpParams = (this.params == null || this.params == '')? null : this.params;
		var httpUrl = this.url;
		if(httpMethod == 'GET' && httpParams != null){
			httpUrl = httpUrl + "?" + httpParams;
		}
		this.req.open(httpMethod, httpUrl, true);
		this.req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		var request = this;
		this.req.onreadystatechange = function(){	//XMLHttpRequest ��ü�� readyState ���� �ٲ� ��, �� ��ü(Request ��ü)�� onStateChange �Լ� ȣ��
			request.onStateChange.call(request);
		}
		this.req.send(httpMethod == 'POST' ? httpParams : null);
	},onStateChange : function(){	//�� ��ü�� callback ������Ƽ�� �Ҵ�� �Լ��� ȣ���Ѵ�. �̶� ���ڷ� this.req ��ü�� (XMLHttpRequest ��ü��) �����Ѵ�.
		this.callback(this.req);
	}
}
