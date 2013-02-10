//ActsAsStatusBar

var instanceNo = 0;
var ActsAsStatusBar = Class.create();
ActsAsStatusBar.prototype = {
	initialize: function(progressBarContainerElementId,progressBarMessageId,progressBarValueId,progressBarElementId, barElementId, initProperties){
		this.progressBarContainerElement = document.getElementById(progressBarContainerElementId);
		this.progressMessage = document.getElementById(progressBarMessageId);
		this.progressValue = document.getElementById(progressBarValueId);
		this.progressBarElement = document.getElementById(progressBarElementId);
		this.barElement = document.getElementById(barElementId);
		if( initProperties != null ){
			this.frequency = initProperties["frequency"];
			this.url = initProperties["url"];
			this.total = initProperties["total"];
		}else{ this.frequency = 2; }
		this.value = 1;
		this.display_value = "";
		this.display_message = "";
		this.isFinish = false;
		this.repaint();
		this.id = "AjaxProgressBar"+ instanceNo++;
		window[this.id] = this;
	},
	setValue: function(value){ this.value = value; this.repaint(); },
	
	setDisplayValue: function(display_value, display_message){
		 this.display_value = display_value;
		 this.display_message = display_message; 
		 this.repaint();
 	},
	
	//Update div content on the page
	repaint: function(){
		if( this.value >= 0 && this.value <= 100 ){
			this.barElement.style.width = this.value +"%";
			this.progressValue.innerHTML = this.display_value;
			this.progressMessage.innerHTML = this.display_message;
		}
	},
	start: function(){ this.progressBarContainerElement.style.visibility = 'visible'; this.update(); },
	update: function(){
		var upThis = this;
		var ajax = new Ajax.Request(this.url, {
			method: "get",
			onSuccess: function(res){ upThis.updateSuccess(res); },
			onFailure: function(res){ alert("Error: "+ res.status +" "+ res.statusText);}
		});
		if(!this.isFinish )
		{
			setTimeout("window."+ this.id +".update()", this.frequency*1000);
		}
		else
		{
			this.progressBarContainerElement.style.visibility = 'hidden';
		}
	},
	updateSuccess: function(res){
		var value = res.responseXML.getElementsByTagName("value")[0].firstChild.nodeValue;
		var message = res.responseXML.getElementsByTagName("message")[0].firstChild.nodeValue;
		var percent = parseInt(res.responseXML.getElementsByTagName("percent")[0].firstChild.nodeValue);
		this.setValue(percent);
		this.setDisplayValue(value,message);
		this.isFinish = percent == 100;
	}
}
