<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<title>1:1Chatting</title>
<%@ include file="/WEB-INF/views/frame/metaheader.jsp"%>
<link rel="stylesheet" href="/gym/css/user_chat.css">
<script
	src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
</head>
<body>
	<!-- header -->
	<%@ include file="/WEB-INF/views/frame/header.jsp"%>



	<div id="chatwarp">
			<div id="chatlist_wrap">
			<div class="chatid">
				<h3>${member.memnick}</h3>
			</div>
				<!-- 채팅방 리스트 시작 -->
				<c:forEach items="${chatList}" var="list">
					<div class="chatlist">
						<button type="button" value="${list.crnick}"
							onclick="getChatidx(${list.chatidx}); location.href='javascript:chatList(${list.chatidx})'"
							class="on_btn">
							<div class="float_left">
								<img src="<c:url value="/images/icon/profile2.png"/>">
							</div>
							<div class="float_left chat_name">
								<h3>${list.crnick}</h3>
							</div>
							<div class="chat_title">
								<span>${list.placename}</span>
							</div>
							<div class="chat_title_img">
							</div>
							<div class="chat_content">
								<span><%-- ${list.chatcontent} --%>
								</span>
							</div>
							<div class="chat_date">
								<span> <%-- ${list.chatdate} --%>
								</span>
							</div>
						</button>
					</div>
				</c:forEach>
			</div>
				<!-- 채팅방 리스트 끝 -->
			<div id="chatcontent_warp">
			<!-- <form onsubmit="return sendMessage();"> -->
				<!-- 채팅룸 nav -->
				<div class="message_warp">
				</div>
				<div class="chat_null" id="output">
					<div class="carry_message_warp">
						<div class="carry_chat">
							<div class="message">
								<div class="message_color">
								</div>
							</div>
							<div class="time_line">
							</div>
						</div>
					</div>
				<div class="user_message_warp">
					<div class="user_chat">
						<div class="user_message">
							<div>
								<span></span>
							</div>
						</div>
						<div class="time_line2">
							<span></span>
						</div>
					</div>
				</div>
				</div>
				<div class="chatting_write">
				<input type="text" placeholder="메세지 입력.." id="msg">
				<button type="button" class="btn" id="btnSend">
				<img src="<c:url value="/images/icon/icoin.png"/>">
				</button>
				</div>
				<!-- </form> -->
			</div>
			
			<div id="chatcontent_off">
				<div class="not_message">
					<img src="<c:url value="/images/icon/chat.png"/>"
						style="width: 80px;">
					<h3>채팅할 상대를 선택해주세요</h3>
				</div>
			</div>
		</div>
	<!-- footer -->
	<%@ include file="/WEB-INF/views/frame/footer.jsp"%>
	
	<script>
		$(document).ready(function() {
			$(".chat_null").hide();
			$(".message_warp").hide();
			$(".chatting_write").hide();
			
			$(".chatlist .on_btn").click(function() {
				$(".chatlist .on_btn").removeClass('active');
				$(this).addClass('active');
				$("#chatcontent_off").hide();
				$('#span_off').hide();
			});
		});
		
		function chatNav(){
			var htmlNav = '<ul>';
			htmlNav += '<li class="back_button"><a href="#" onclick="history.go(0)"><img src="<c:url value="/images/icon/arrow.png"/>"</a></li>';
			htmlNav += '<li><a href="#"><img src="<c:url value="/images/icon/ellipsis-h-solid.svg"/>" style="width: 40px;"></a></li>'
			htmlNav += '<li><a href="#"><img src="<c:url value="/images/icon/heart2.png"/>" style="width: 40px;"></a></li>'
			htmlNav += '<li><a href="#"><img src="<c:url value="/images/icon/garbage.png"/>" style="width: 40px;"></a></li>'
			htmlNav += '<li class="order_button"><input type="button" value="결제하기"></li>'
			htmlNav += '</ul>'
			$('.message_warp').html(htmlNav);
		}
		
		function chattting(){
			var htmlStr = '<div>'
				htmlStr += '<div class="message_warp"></div>'
				htmlStr += '<div class="chat_null" id="output">';
				htmlStr += '	<div class="carry_message_warp">'
				htmlStr += '		<div class="carry_chat">'
				htmlStr += '		<div class="time_line"><span></span></div>'
				htmlStr += '		</div>'
				htmlStr += '	</div>'
				htmlStr += '</div>'
				htmlStr += '<div class="chatting_write">'
				htmlStr += '<input type="text" placeholder="메세지 입력.." id="msg">'
				htmlStr += '<input type="hidden" value="${member.memnick}" id="memberId">'
				htmlStr += '<button type="button" class="btn" id="btnSend">'
				htmlStr += '<img src="<c:url value="/images/icon/icoin.png"/>">'
				htmlStr += '</button>'
				htmlStr += '</div>'					
				htmlStr += '</div>'					
			$('#chatcontent_warp').html(htmlStr);
			
			//$('.carry_message_warp').append(htmlStr);
			chatNav();
			
			// 처음 접속시, 메세지 입력창에 focus 시킴
			$('#msg').focus();
			
			$('#btnSend').click(function(event){
				event.preventDefault();
				var msg = $('input#msg').val();
				//sock.send(msg);
				sendMessage();
				
				// 메세지 입력창 내용 보내고 지우기.
				$('#msg').val('');
				$("#output").scrollTop($(document).height());
			});	
			
			$('#msg').keypress(function(event){
				if (event.keyCode == 13 && $('input#msg').val().trim().length >= 1) {
					event.preventDefault();
					var msg = $('input#msg').val();
					//sock.send(msg);
					sendMessage();
					// 메세지 입력창 내용 보내고 지우기.
					$('#msg').val('');
					$("#output").scrollTop($(document).height());
				}
			});	
			
			
		}
	</script>

	<script>
	var socket = new SockJS("<c:url value='/echo'/>");
	// open - 커넥션이 제대로 만들어졌을 때 호출
	socket.onopen = function() {
		// 방오픈 됫는지 확인 메세지
		console.log('connection opend.');
	};
	
	// onmessage - 커넥션이 메세지 호출
	socket.onmessage = function(message) {
		var data = message.data;
		var jsonData = JSON.parse(data);
		console.log(jsonData); 
		
		var currentuser_session = $('#memberId').val();
		
		if (jsonData.memnick == currentuser_session) {
			var htmlStr = '<div class="carry_chat">'
				htmlStr += '<div class="carry_line"><img src="<c:url value="/images/icon/profile2.png"/>"></div>'
				htmlStr += '<div class="message">'
				htmlStr += '<div class="message_color">'
				htmlStr += '<span>'+jsonData.chatcontent+'</span>'
				htmlStr += '</div>'
				htmlStr += '</div>'
				htmlStr += '<div class="time_line"><span></span></div>'
				htmlStr += '</div>'
				htmlStr += '</div>'
			$('.chat_null').append(htmlStr);
				
		} else {
			var htmlStr = '	<div class="user_message_warp">'
				htmlStr += '		<div class="user_chat">'
				htmlStr += '			<div class="user_message">'
				htmlStr += '				<div>'
				htmlStr += '					<span>'+jsonData.chatcontent+'</span>'
				htmlStr += '				</div>'
				htmlStr += '			</div>'
				htmlStr += '			<div class="time_line2">'
				htmlStr += '				<span></span>'
				htmlStr += '			</div>'
				htmlStr += '		</div>'
				htmlStr += '	</div>'

			$('.chat_null').append(htmlStr);
		}

		console.log('chatting data: ' + data);	
		
		
	};

	// close - 커넥션이 종료되었을 때 호출
	socket.onclose = function(event) {
		console.log('connection closed.');
	};

	// error - 에러가 생겼을 때 호출
	socket.onerror = function(error) {
		console.log('connection Error.')
	};
	
	
	var chatidx;
	function getChatidx(num){
		chatidx = num;
	}
		
	// 객체를 json형태로 담아 보냄
	function sendMessage() {
		// 메세지 입력값이 빈공간이 아니면 멤버닉네임, 캐리닉네임, 대화내용 담기
		var msg = {
			memnick : '${member.memnick}',
			crnick : '황철순',
			chatidx : chatidx,
			chatcontent : $('#msg').val()
		};
		console.log(msg);
		// 사용자닉네임, 캐리닉네임, 메세지 send 보낸다.
		socket.send(JSON.stringify(msg));
	}; 
	
		
	</script>

	<script>
		// 채팅방 대화내용 리스트
		function chatList(num) {
			$.ajax({
				type : 'GET',
				url : '<c:url value="/chatting/dochat"/>',
				dataType : 'json',
				data : {
					chatidx : num
					},
					success : function(data) {
						if (data == 0) {
							chattting();
							chatNav();
						} else {
							var htmlStr = '<div class="carry_message_warp">';
							$.each(data, function(index, item) {
								if(item.contenttype == 1){
									htmlStr += '<div class="carry_chat">'
									htmlStr += '	<div class="carry_line"><img src="<c:url value="/images/icon/profile2.png"/>"></div>'
									htmlStr += '	<div class="message">'
									htmlStr += '		<div class="message_color">'
									htmlStr += '			<span>'+item.chatcontent+'</span>'
									htmlStr += '		</div>'
									htmlStr += '	</div>'
									htmlStr += '	<div class="time_line"><span>'+item.chatdate+'</span></div>'
									htmlStr += '	</div>'
									htmlStr += '</div>'
								} else if(item.contenttype == 0){
									htmlStr += '	<div class="user_message_warp">'
									htmlStr += '		<div class="user_chat">'
									htmlStr += '			<div class="user_message">'
									htmlStr += '				<div>'
									htmlStr += '					<span>'+item.chatcontent+'</span>'
									htmlStr += '				</div>'
									htmlStr += '			</div>'
									htmlStr += '			<div class="time_line2">'
									htmlStr += '				<span>'+item.chatdate+'</span>'
									htmlStr += '			</div>'
									htmlStr += '		</div>'
									htmlStr += '	</div>'
								}
							chattting();
							
						});
					}
				}
			})
		}
	</script>
	
	