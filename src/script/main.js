var controller = {
	init:function()
	{
		$("#signature").jSignature({color:"#3e3e3e",lineWidth:3});
		$("#btnReset").on('click',function(e){
			e.preventDefault();
			$("#signature").jSignature('reset');
		});
		$("#btnSave").on('click',function(e){
			var data = $("#signature").jSignature('getData','image');
			$("#sigData").val(data);
			if(true || confirm('Please save the generated PDF, and forward it to your researcher.'))
			{
				$("#consentForm").submit();
			}
		});
	}
};

