
function HtmlDecoder(){
	var converters=new Map();//转换器列表，转换器是根据Element获取文本的函数。这里的Map函数是另外一个函数，相当于C#中的Dictionary。
	this.RegisterConverter=function(tagName,conv){//登记转换器，为转换器列表添加内容
		if (converters.ContainsKey(tagName))
        {
			var index=converters.IndexOfKey(tagName);//如果已经存在对应tagName的转换器，就替换之
            converters.RemoveAt(index);
			if(conv)converters.Add(tagName,conv);
        }
        else
        {			
            if(conv)converters.Add(tagName,conv);
        }
	}
    this.Decode=function(self){return function(ele){//外部要调用的解析函数
	    if(ele.style&&ele.style["display"]=="none")return "";//如果Element是隐藏的就返回“”
	    var items=ParseElementChildren(ele);//调用“解析子元素”函数，获得Element的所有子元素
		var s="";
		if(!items||items.length<1){//如果没有子元素就调用对应“tagName”的转换器，获取该元素的文本内容
 			var conv=GetConverter(ele.tagName);
			s=conv(ele);
		}
		else{							//如果有子元素就遍历之
		    for(var i=0;i<items.length;i++){
				if(!items[i])continue;
				if((typeof items[i])=="string"){//若子元素是文本，就获取
					s+=items[i];
				}
				else{
				    s+=self.Decode(items[i]);//如果子元素是不是文本就递归，进行解析
				}
			}
			switch(ele.tagName){		//根据tagName添加制表符
				case "P":
				case "DIV":
				    s+="\r\n";
					break;
			}
		}
		return s;
	}}(this);
	function GetConverter(tagName){//根据tagName获取转换器，
	    if(converters.ContainsKey(tagName))return converters.ValueForKey(tagName);		
	    return UnknownDecode;
	}
	function UnknownDecode(ele){
	    return ele.innerText;
	}
	function ParseElementChildren(ele){//解析Element，获取其子元素
	        if(ele.childNodes.length<1)return null;
			switch(ele.tagName){
			    case "IMG":
				case "INPUT":
				case "BR":
				case "HR":
				case "SELECT":
				case "TABLE":
				    return null;
				case "P":
				case "DIV":
				case "SPAN":
				default:
				//此部分比较复杂，原理是：将Element子元素的outerHTML作为分隔符，将文本部分也作为子元素，加入到items数组
				    var items=[];
 					var html=ele.innerHTML;
					html=html.replace(/\s+/g, "");
					var pos=0;
					for(var i=0;i<ele.childNodes.length;i++){
					    var outer=ele.childNodes[i].outerHTML;
						if(outer){
						    outer=outer.replace(/\s+/g, "");
						    var index=html.indexOf(outer,pos);
						    if(index-pos>0){
								items[items.length]=html.substr(pos,index-pos);
								pos=index;
							}
							items[items.length]=ele.childNodes[i];
							pos+=outer.length;
						}
					}
					if(pos<html.length)items[items.length]=html.substr(pos);
					return items;
			}
	}
	//-----------------------此处登记部分常用类型转换器--------------------
    this.RegisterConverter("IMG",function(){return "";});
    this.RegisterConverter("INPUT",function(ele){return ele.value;});
    this.RegisterConverter("BR",function(){return "\r\n"});
    this.RegisterConverter("HR",function(){return ""});
    this.RegisterConverter("SELECT",function(ele){
	if(ele.options.length<1) return "";
	return ele.options[ele.selectedIndex].text;});
    this.RegisterConverter("P",function(ele){return ele.innerText+"\r\n";});
    this.RegisterConverter("DIV",function(ele){return  ele.innerText+"\r\n";});
    this.RegisterConverter("SPAN",function(ele){return ele.innerText+"\r\n";});
    this.RegisterConverter("TABLE",function(d){return function(ele){
	var s="";
	for(var r=0;r<ele.rows.length;r++){
		var tr=ele.rows[r];
		for(var c=0;c<tr.cells.length;c++){
			s+=d.Decode(tr.cells[c])+"\t";
		}
		s+="\r\n";
	}
	return s;};}(this));
}

function Map()
{
    var keys=[];
    var values=[];
    this.Count=0;
    var self=this;
    this.ContainsKey=function(key){
        return self.IndexOfKey(key)>-1;
    }
    this.ContainsValue=function(value){
        return self.IndexOfValue(value)>-1;
    }
    this.IndexOfKey=function(key){
        for(var i=0;i<keys.length;i++){
            if(keys[i]==key)return i;
        }
        return -1;
    }
    this.IndexOfValue=function(value){
        for(var i=0;i<values.length;i++){
            if(values[i]==value)return i;
        }
        return -1;
    }
    this.Insert=function(index,key,value){
        if(self.ContainsKey(key))throw new Error("Key exists");
        if(self.ContainsValue(key))throw new Error("Value exists");
        for(var i=keys.length;i>index;i--){
            keys[i]=keys[i-1];
        }
        keys[index]=key;
        for(var i=values.length;i>index;i--){
            values[i]=values[i-1];
        }
        values[index]=value;
        self.Count++;
    }
    this.Add=function(key,value){
        self.Insert(self.Count,key,value);
    }
    this.RemoveAt=function(index){
        if(index<0||index>=self.Count)throw new Error("Index out of range");
        for(var i=index;i<keys.length;i++){
            keys[i-1]=i;
        }
        keys.length--;
        for(var i=index;i<values.length;i++){
            values[i-1]=i;
        }
        values.length--;
        self.Count--;
    }
    this.Clear=function(){
        keys.length=0;
        values.length=0;
        self.Count=0;
    }
    this.ValueForKey=function(key){
        var index=self.IndexOfKey(key);
        return values[index];
    }
    this.KeyAt=function(index){
        return keys[index];
    }
}
