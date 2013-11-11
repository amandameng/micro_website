$(function(){
	
	var insert1 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入标题</div><input class='txtArea' type='text' /></div>";
	
	var insert2 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='radio' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";
	
	var insert3 = "<div class='insertBox'><span class='delete'></span><div class='inputArea'>双击输入问题</div><input class='txtArea' type='text' /><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div><div><input type='checkbox' /><div class='inputArea'>双击输入选项</div><input class='txtArea' type='text' /></div></div>";
	
	$(".addElemt1").click(function(){
		$(".insertDiv").append(insert1);
	});
	$(".addElemt2").click(function(){
		$(".insertDiv").append(insert2);
	});
	$(".addElemt3").click(function(){
		$(".insertDiv").append(insert3);
	});
	
	$(".formTit input").focus(function(){
		if($(this).val() == "在这输入表单标题"){
			$(this).val("");
			$(this).css("color","#2C2C2C");
		}
	});
	$(".formTit input").blur(function(){
		if($(this).val() == ""){
			$(this).val("在这输入表单标题");
			$(this).css("color","#A7A7A7");
		}
	});
	
	$(".insertDiv").on("dblclick",".inputArea",function(){
		$(this).hide();
		$(this).parent().children(".txtArea").show();
		$(this).parent().children(".txtArea").focus();
	});
	
	$("tr").each(function(){
		var table = $(this).parents("table");
		var i = table.find("tr").index($(this));
		if(i % 2 ==0 && i != 0){
			$(this).css("background","#F2F6F6");
		}
	});
	
	$(".second_box .close").click(function(){
		$(this).parents(".second_box").hide();
		$(".second_bg").hide();
	});
	$(".insertDiv").on("click",".delete",function(){
		$(this).parent().remove();
	});
	
	$(".theTab").click(function(){
		$(".theTab").removeClass("used");
		$(".tabDiv").removeClass("used");
		$(this).addClass("used");
		var i = $(".theTab").index(this);
		//alert(i);
		$(".tabDiv").eq(i).addClass("used");
	});
	
	$(".check_input").blur(function(){
		if($(this).val() == ""){
			$(this).parent().find(".check").css("color","#ff0000");
		}else{
			$(this).parent().find(".check").css("color","#ffffff");
		}
	});
	
	$("button.newPage").click(function(){
		$(".tabDiv").hide();
		$(".tabDiv.newPage").show();	
	});
	
	$(".page_tit input").blur(function(){
		if($(this).val() == ""){
			$(this).parent().find("span").css("color","#ff0000");
		}else{
			$(this).parent().find("span").css("color","#e9ebea");
		}
	});
	
	$(".scd_btn").click(function(){
		$(".second_bg").show();
		$(".second_box."+$(this).attr("name")).show();
	})
	
	$(".file_1").change(function(){
		$(this).parents(".fileBox").find(".fileText_1").val($(this).val());
	});
})