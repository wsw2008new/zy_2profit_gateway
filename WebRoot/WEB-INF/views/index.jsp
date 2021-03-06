<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@include file="common/common.jsp"%>
<%@ include file="common/nice-validator.jsp" %>

</head>

<script type="text/javascript">

	var params = '';
	var currentPage = 1;
	var totalSize = 10;
	
	
	$(function() {

		headerAddClass();

		$('div[data-ui="header"]').addClass('index');
		
		setCurrentMenu('index');
		
		brokerHtml(currentPage);
		
		$('a[name=orderBy_href]').click(function(e){
			e.preventDefault();
			
    		if($(this).attr("class")=='up'){
    			if($(this).children("input").val()=='min_income_money'){
    				params = 'min_income_money,desc';
    			}else if($(this).children("input").val()=='is_in_out_free'){
    				params = 'is_in_out_free,desc';
    			}else if($(this).children("input").val()=='commission_llg'){
    				params = 'commission_llg,desc';
    			}else if($(this).children("input").val()=='is_recommet'){
    				params = 'is_recommet,desc';
    			}else if($(this).children("input").val()=='lever_rate'){
    				params = 'lever_rate,desc';
    			}
    		}else if($(this).attr("class")=='down'){
    			if($(this).children("input").val()=='min_income_money'){
    				params = 'min_income_money,asc';
    			}else if($(this).children("input").val()=='is_in_out_free'){
    				params = 'is_in_out_free,asc';
    			}else if($(this).children("input").val()=='commission_llg'){
    				params = 'commission_llg,asc';
    			}else if($(this).children("input").val()=='is_recommet'){
    				params = 'is_recommet,asc';
	    		}else if($(this).children("input").val()=='lever_rate'){
					params = 'lever_rate,asc';
				}
    		}
    		brokerHtml(currentPage);
	    });
		
		$('input[name=bkName]').keyup(function(e){
			e.preventDefault();
			brokerHtml(currentPage);
		});
		
	});
	
	function brokerHtml(currentPage){
		
		$.ajax({
   			url:'${ctx}/brokers',
   			type:'GET',
   			async:false,
   			data:{
   				'orderByP':params,
   				'bkName':$('input[name=bkName]').val(),
   				"currentPage":currentPage
   			},
   			success:function(json){
   				if(json.success){
   					var html = '';
   		   			var pageModel = json.pageModel;
   		   			var model = json.model;
   		   			currentPage = json.pageModel.currentPage;
   		   			totalSize = json.pageModel.totalCount;
   		   			
   		   			//修改排序箭头指向
   		   			if(model.arrow_min_income_money=='desc'){
   		   				$('#arrow_min_income_money').attr('class','down');
   		   			}else if(model.arrow_min_income_money=='asc'){
   		   				$('#arrow_min_income_money').attr('class','up');
   		   			}
   		   			if(model.arrow_profit_star=='desc'){
   		   				$('#arrow_profit_star').attr('class','down');
   		   			}else if(model.arrow_profit_star=='asc'){
   		   				$('#arrow_profit_star').attr('class','up');
   		   			}
   		   			if(model.arrow_commission_llg=='desc'){
   		   				$('#arrow_commission_llg').attr('class','down');
   		   			}else if(model.arrow_commission_llg=='asc'){
   		   				$('#arrow_commission_llg').attr('class','up');
   		   			}
   		   			if(model.arrow_is_recommet=='desc'){
   		   				$('#arrow_is_recommet').attr('class','down');
   		   			}else if(model.arrow_is_recommet=='asc'){
   		   				$('#arrow_is_recommet').attr('class','up');
   		   			}
   		   			if(model.arrow_is_in_out_free=='desc'){
   		   				$('#arrow_is_in_out_free').attr('class','down');
   		   			}else if(model.arrow_is_in_out_free=='asc'){
   		   				$('#arrow_is_in_out_free').attr('class','up');
   		   			}
   		   			if(model.arrow_lever_rate=='desc'){
   		   				$('#arrow_lever_rate').attr('class','down');
   		   			}else if(model.arrow_lever_rate=='asc'){
   		   				$('#arrow_lever_rate').attr('class','up');
   		   			}
   		   			
   		   			for(var i=0; i<pageModel.list.length; i++){
   		   				var broker = pageModel.list[i];
   		   				
   		   				var exchangeInfo = '';
   		   				if(broker.exchangeNo1!=''){
   		   					exchangeInfo = '金银业贸易场('+ broker.exchangeNo1+ ') ';
   		   				}else if(broker.exchangeNo2!=''){
   		   					exchangeInfo = '证监会('+ broker.exchangeNo2+ ') ';
   		   				}else if(broker.exchangeNo3!=''){
   		   					exchangeInfo = '英国FCA('+ broker.exchangeNo3+ ') ';
   		   				}else if(broker.exchangeNo4!=''){
   		   					exchangeInfo = '日本FSA('+ broker.exchangeNo4+ ') ';
   		   				}
   		   				
   		   				var leverRate = '&nbsp;';
   		   				if(broker.leverRate!=null && broker.leverRate!=0){
   		   					leverRate = '最大杠杆：1:'+ broker.leverRate;
   		   				}
   		   				
   		   				var isRecommet = '<span></span>';
   		   				if(broker.isRecommet == 1){
   		   					isRecommet = '<span>至盈推荐</span><img src="${ctx }/static/images/good_orange.png" />';
   		   				}
   		   				
   			   			html += '<div class="m_item">'+
   									'<div class="i_pic">'+
   										'<div class="p_logo">'+
   											'<img style="width: 140px; height: 46px;" src="${ctx}/'+broker.imageUrl+'" />'+
   										'</div>'+
   										'<div class="p_num">'+broker.commissionLlg +'美元</div>'+
   										'<div class="p_txt">黄金返佣</div>'+
   										'<div class="p_over">'+
   											'<i class="icon">󰅖</i><span>2020</span>已申请'+
   										'</div>'+
   										'<div class="p_btn">'+
   											'<a href="${ctx }/main/person"><img src="${ctx }/static/images/mskh_btn_bg.png" /></a>'+
   										'</div>'+
   									'</div>'+
   									'<div class="i_info clearfix">'+
   										'<div class="i_left">'+
   											'<div class="l_name">'+ broker.cnName +'</div>'+
   											'<div class="l_txt">'+
   												'<span class="cRed">优势</span>：'+ exchangeInfo +
   											'</div>'+
   											'<div class="l_txt">点差：黄金'+ broker.pointDiffMinLlg +'</div>'+
   											'<div class="l_txt">最少入金：'+ broker.minIncomeMoney +'</div>'+
   											'<div class="l_txt">最小交易：'+ broker.minTradeNumLlg +'</div>'+
   											'<div class="l_txt">最小开户：'+ broker.openMoneyLlg +'</div>'+
   											'<div class="l_txt">'+ leverRate +'</div>'+
   										'</div>'+
   										'<div class="i_right">'+
   											'<div class="r_txt">'+ isRecommet +'</div>'+
   											'<div class="r_btn">'+
   												'<a class="abtn green" href="#">优惠活动</a>'+
   											'</div>'+
   											'<div class="r_btn">'+
   												'<a class="abtn orange" href="${ctx}/bk/detail?id='+ broker.id +'">了解详情</a>'+
   											'</div>'+
   										'</div>'+
   									'</div>'+
   								'</div>';
   		   			}//for
   		   			$("#append_div").empty();
	   				$('#append_div').append(html);
	   				
	   				if(currentPage>=1){
						currentPage=currentPage-1;
					}
	   				
				 	if(totalSize > 0){
					 	$("#pagination").pagination(totalSize,{
							items_per_page : 6,
							num_display_entries : 5,
							current_page : currentPage,
							num_edge_entries : 0,
							link_to : "javaScript:void(0);",
							prev_text : "前一页",
							next_text : "下一页",
							ellipse_text : "...",
							prev_show_always : true,
							next_show_always : true,
							callback : function(index) {
								currentPage = index+1;
								brokerHtml((index+1));
							}
						});
				  	}
   				}//json.success
   			}//success function			
		});
	}

	function dialogBackDiscount(){
		
		/* <c:if test="${empty loginUser }">
			jc.alert('请先登录', function(){
				window.location.href = '${ctx}/login';
			});
			return;
		</c:if> */
		
		jc.dialog.get("${ctx}/dialog/back_discount",
			function(obj){
				obj.show();
			}, "back_discount");
		
	}
	
</script>

<body>
	<jsp:include page="common/head.jsp" />

	<c:if test="${empty loginUser }">
	<div data-ui="loginWrap" class="J_loginWrap">
		<div class="l_left">
			<div class="J_toolsBar">
				<div class="t_label">跟随顶尖交易员投资</div>
				<div class="ml10 t_button">
					<a class="abtn green" href="${ctx }/register">立即注册</a>
				</div>
			</div>

		</div>
		<div class="l_right">
			<form action="" id="loginForm">
				<div class="J_toolsBar">
					<div class="t_text w180">
						<label> <input placeholder="手机号码/邮箱" type="text"
							name="username" />
						</label>
					</div>
					<div class="ml10 t_text w180">
						<label> <input placeholder="密码" type="password"
							name="pwd" />
						</label>
					</div>
					<div class="ml10 t_button">
						<a class="abtn red" href="javascript:myLoginSubmit('/main');">登录</a>
					</div>

					<div class="ml20 t_label">社交帐号登录</div>

					<div class="ml10 t_icon">
						<!-- <a class="i_link i_sina" href="#"></a>
                    <a class="i_link i_qq" href="#"></a> -->
						<a class="i_link i_wx" href="#"></a>
					</div>
				</div>
			</form>			
		</div>
	</div>
	</c:if>
	
	<div data-ui="indexMask" class="J_indexMask"></div>

	<div data-ui="silder" class="J_silder">
		<div class="s_main">
            <div class="m_item" style="background-image: url(${ctx}/static/tmp/b1.png)"><a href="#"></a></div>
            <div class="m_item" style="background-image: url(${ctx}/static/tmp/b2.png)"><a href="#"></a></div>
            <div class="m_item" style="background-image: url(${ctx}/static/tmp/b3.png)"><a href="#"></a></div>
        </div>
		<div class="s_controller"></div>
		<div class="s_step">
			<a class="s_btn b_left" href="javascript:void(0);">
                <img src="${ctx}/static/images/b_left.png" />
            </a>
            <a class="s_btn b_right" href="javascript:void(0);">
                <img src="${ctx}/static/images/b_right.png" />
            </a>
		</div>
	</div>

	<!-- 经纪商 -->
	<form action="index" name="form" id="form" method="post" theme="simple">
	<div class="J_content mt-260 bgfff hasShadow" id="afterPageAnchor">
		<div class="fl c_760">
			<div class="pau">

				<div class="J_jjsHeader clearfix">
					<div class="j_left"></div>
					<div class="j_right">
						<div class="r_top clearfix">
							<div class="t_left">
								<input placeholder="经纪商 （中文/英文）" type="text" name="bkName" value="${queryDto.bkName }"/>
							</div>
							<div class="t_right">
							<a 	<c:choose>
	                           		<c:when test="${queryDto.arrow_is_recommet == 'desc'}">class='down'</c:when>
	                           		<c:when test="${queryDto.arrow_is_recommet == 'asc'}">class='up'</c:when>
	                           		<c:otherwise>class='down'</c:otherwise>
                           		</c:choose>
								id='arrow_is_recommet' name='orderBy_href' href="#">至盈推荐<input type="hidden" value="is_recommet"><span></span></a>
							</div>
						</div>
						<div class="r_bottom clearfix">
							<a 	<c:choose>
	                           		<c:when test="${queryDto.arrow_commission_llg == 'desc'}">class='down'</c:when>
	                           		<c:when test="${queryDto.arrow_commission_llg == 'asc'}">class='up'</c:when>
	                           		<c:otherwise>class='down'</c:otherwise>
                           		</c:choose>
								id='arrow_commission_llg' name='orderBy_href' href="#">黄金返佣<input type="hidden" value="commission_llg"><span></span></a> 
							<a 	<c:choose>
	                           		<c:when test="${queryDto.arrow_min_income_money == 'desc'}">class='down'</c:when>
	                           		<c:when test="${queryDto.arrow_min_income_money == 'asc'}">class='up'</c:when>
	                           		<c:otherwise>class='down'</c:otherwise>
                           		</c:choose>
								id='arrow_min_income_money' name='orderBy_href' href="#">最低开户入金<input type="hidden" value="min_income_money"><span></span></a> 
							<a 	<c:choose>
	                           		<c:when test="${queryDto.arrow_is_in_out_free == 'desc'}">class='down'</c:when>
	                           		<c:when test="${queryDto.arrow_is_in_out_free == 'asc'}">class='up'</c:when>
	                           		<c:otherwise>class='down'</c:otherwise>
                           		</c:choose>
								id='arrow_is_in_out_free' name='orderBy_href' href="#">出入金免手续费<input type="hidden" value="is_in_out_free"><span></span></a> 
							<a 	<c:choose>
	                           		<c:when test="${queryDto.arrow_lever_rate == 'desc'}">class='down'</c:when>
	                           		<c:when test="${queryDto.arrow_lever_rate == 'asc'}">class='up'</c:when>
	                           		<c:otherwise>class='down'</c:otherwise>
                           		</c:choose>
								id='arrow_lever_rate' name='orderBy_href' href="#">最大的杠杆<input type="hidden" value="lever_rate"><span></span></a>
						</div>
					</div>
				</div>


				<div class="J_jjsList">
					<div class="j_inner">
						<div class="i_main" id="append_div">
							
						</div>
					</div>
				</div>
                
                <%-- <div class="j_page">
                	<tr><td colspan="50" style="text-align:center;"><%@ include file="common/pager.jsp"%></td></tr>
                </div> --%>
                
                <br/>
                <div class="J_page" id="pagination"></div>			

			</div>
		</div>
		<div class="fr c_430">
			<div class="pau">

				<div class="J_btnList">
					<div class="b_item big">
						<a href="javascript:dialogBackDiscount()">申请返佣</a>
					</div>
					<div class="b_item">
						<a class="i1" href="${ctx }/bk/list"><span></span>更多经纪商</a>
					</div>
					<div class="b_item">
						<a class="i2" href="javascript:void(0)"><span></span>赠金优惠</a>
					</div>
					<div class="b_item">
						<a class="i3" href="javascript:void(0)"><span></span>外汇资讯</a>
					</div>
				</div>

				<div class="J_titleGray mt20">
					<div class="t_txt">行情</div>
				</div>

				<div data-ui="market" class="J_market">
					<div class="m_table">
						<table>
							<tbody>
								<tr class="up">
									<td>伦敦金/美元</td>
									<td><i class="icon">󰄓</i></td>
									<td>1172.19</td>
									<td>-10.26</td>
								</tr>
								<tr class="down">
									<td>伦敦金/美元</td>
									<td><i class="icon">󰄑</i></td>
									<td>1172.19</td>
									<td>-10.26</td>
								</tr>
								<tr class="down">
									<td>美元指数</td>
									<td><i class="icon">󰄑</i></td>
									<td>1172.19</td>
									<td>-10.26</td>
								</tr>
								<tr class="down">
									<td>纽约原油</td>
									<td><i class="icon">󰄑</i></td>
									<td>1172.19</td>
									<td>-10.26</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="m_tab mt20">
						<div class="t_title">
							<div class="t_item active">
								<a href="javascript:;">伦敦金</a>
							</div>
							<div class="t_item">
								<a href="javascript:;">伦敦银</a>
							</div>

						</div>
						<div class="t_main">
							<div class="m_item active">
								<img style="width: 100%;" src="${ctx }/static/tmp/tmp_kline.png" />
							</div>
							<div class="m_item">
								<img style="width: 100%;" src="${ctx }/static/tmp/tmp_kline.png" />
							</div>
						</div>
					</div>

				</div>


				<div class="J_titleGray mt20">
					<div class="t_txt">返佣流程</div>
				</div>
				<div class="J_step">
					<div class="s_item">
						<div class="i_left">
							<div class="l_icon">1</div>
						</div>
						<div class="i_right">
							<div class="r_title">注册会员开户</div>
							<div class="r_info">于至盈网注册登记成为会员</div>
						</div>
					</div>

					<div class="s_item">
						<div class="i_left">
							<div class="l_icon">2</div>
						</div>
						<div class="i_right">
							<div class="r_title">选择经纪商</div>
							<div class="r_info">选择适合您的经纪商</div>
						</div>
					</div>

					<div class="s_item">
						<div class="i_left">
							<div class="l_icon">3</div>
						</div>
						<div class="i_right">
							<div class="r_title">在2Profit开户</div>
							<div class="r_info">在2Profit进行开户，只有在本站开户才能获得返佣。</div>
						</div>
					</div>
					<div class="s_item">
						<div class="i_left">
							<div class="l_icon">4</div>
						</div>
						<div class="i_right">
							<div class="r_title">申请返佣</div>
							<div class="r_info">开户完成后，请您点击“申请返佣” 进行信息登记。</div>
						</div>
					</div>
					<div class="s_item">
						<div class="i_left">
							<div class="l_icon">5</div>
						</div>
						<div class="i_right">
							<div class="r_title">最终确认</div>
							<div class="r_info">工作人员会在1个工作日内通知申请结果。</div>
						</div>
					</div>

				</div>


				<div class="J_titleGray mt20">
					<div class="t_txt">返佣规则</div>
				</div>

				<div class="J_rule">

					<p>1、确认通过金斧子外汇网开户并在线提交了返佣申请。</p>

					<p>2、所有平台实现周返（每周三返上周佣金，法定节假日往后延迟第一个工作日）。</p>

					<p>3、0元起付，没有手数要求和限制。</p>

					<p>4、返佣支付方式为银行卡实时转账，免手续费。</p>

					<p>5、未提到的相关品种返佣比例以外汇平台官方支付给金斧子外汇的90%返还。</p>

					<p>6、返佣服务最终解释权归深圳市金斧子网络科技有限公司所有。</p>
				</div>

				<div class="J_titleGray mt20">
					<div class="t_txt">风险提示</div>
				</div>


				<div class="J_rule">
					<p>投资有风险，入市需谨慎，先求知，再投资，少损失！2Profit提供贵金属外汇平台商开户和返佣，为客户降低交易成本，但不接触客户资金，不参与外汇平台经营和交易；如果外汇平台出现不可抗拒的因素无法出金或返佣，我们也会及时提醒客户，客户需要自行承担风险。</p>
				</div>

			</div>

		</div>
	</div>
	</form>

	<div class="J_content mt20 bgfff hasShadow">
		<div class="fl c_760">
			<div class="pau">
				<div class="J_title">
					<div class="t_txt">至盈社区</div>
					<div class="t_tips"></div>
					<div class="t_more">
						<a href="${ctx }/vote/index/list">更多投票&nbsp;&gt;</a>
					</div>
				</div>

				<div class="J_voteTitle mt10">
					${currentTopic.titleContent }
					<span class="fz14 cOrange">回应数量(${currentTopic.postCount })</span>
				</div>

				<div class="J_voteSuccess mt10">
					<c:forEach items="${currentTopic.options }" var="option"
						varStatus="index">
						<div class="v_item">
							<div class="i_left">${option.optionContent }</div>
							<div class="i_right">
								<c:choose>
									<c:when
										test="${currentTopic.voteCount == null || currentTopic.voteCount == 0 }">
										<div style="width: 0%; background-color: #ee6a53;"
											class="r_bar">
											<div class="b_txt">0%</div>
										</div>
									</c:when>
									<c:otherwise>
										<div
											style="width:<fmt:formatNumber type='number' value='${option.voteCount*100/currentTopic.voteCount}' maxFractionDigits='0'/>%; background-color: #ee6a53;"
											class="r_bar">
											<div class="b_txt">
												<fmt:formatNumber type="number"
													value="${option.voteCount*100/currentTopic.voteCount}"
													maxFractionDigits="0" />
												%
											</div>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:forEach>
				</div>

				<div data-ui="commentsList" class="J_commentsList">
					<div class="c_item">
						<div class="i_left">
							<div class="l_img">
								<c:choose>
			                   		<c:when test="${empty currentTopic.mostPraisePost1.publisher.headUrl }">
			                   			<img src="${ctx }/static/images/userface.jpg"/>
			                   		</c:when>
			                   		<c:otherwise>
			                   			<img src="${ctx }${currentTopic.mostPraisePost1.publisher.headUrl }"/>
			                   		</c:otherwise>
			                   	</c:choose>	
							</div>
							<div class="l_hg"></div>
						</div>
						
						<div class="i_right">
							<div class="r_info clearfix">
								<div class="fl">${fn:substring(currentTopic.mostPraisePost1.publisher.mobile, 0, 3)}****${fn:substring(currentTopic.mostPraisePost1.publisher.mobile, 8, 11)}
									时间:
									<fmt:formatDate
										value="${currentTopic.mostPraisePost1.createDate }"
										type="both" pattern="yyyy-MM-dd HH:mm:ss" />
								</div>
							</div>
							<div class="r_content">${currentTopic.mostPraisePost1.postContent }</div>
						</div>

					</div>

					<div class="c_item">
						<div class="i_left">
							<div class="l_img">
								<c:choose>
			                   		<c:when test="${empty currentTopic.mostPraisePost2.publisher.headUrl }">
			                   			<img src="${ctx }/static/images/userface.jpg"/>
			                   		</c:when>
			                   		<c:otherwise>
			                   			<img src="${ctx }${currentTopic.mostPraisePost2.publisher.headUrl }"/>
			                   		</c:otherwise>
			                   	</c:choose>
							</div>
							<div class="l_hg"></div>
						</div>
						<div class="i_right">
							<div class="r_info clearfix">
								<div class="fl">
									${fn:substring(currentTopic.mostPraisePost2.publisher.mobile, 0, 3) }****${fn:substring(currentTopic.mostPraisePost2.publisher.mobile, 8, 11)}
									时间:
									<fmt:formatDate value="${currentTopic.mostPraisePost2.createDate }"
										type="both" pattern="yyyy-MM-dd HH:mm:ss" />
								</div>
							</div>
							<div class="r_content">${currentTopic.mostPraisePost2.postContent }</div>
						</div>

					</div>

				</div>


				<div class="J_btnGroup mt20 md">
					<a class="abtn green" href="${ctx }/vote/index/list">我要投票</a> 
					<a class="abtn blue" href="${ctx }/vote/index/list">我要回应</a>
				</div>

			</div>


		</div>
		<div class="fr c_430">
			<div class="pau">
				<div class="J_title">
					<div class="t_txt">公告</div>
					<div class="t_tips"></div>
					<div class="t_more"><a href="${ctx }/notice/list">更多公告&nbsp;&gt;</a></div>
				</div>
				<div class="J_cjzxList">
					<div class="c_inner">
						<div class="i_main">
							<c:forEach items="${notices }" var="notice">
	                        	<div class="m_item">
	                                <div class="i_info">
	                                    <div class="i_name"><a href="${ctx }/notice/list?id=${notice.id }">${notice.title }</a></div>
	                                    <div class="i_txt"><i class="icon">󰃄</i>
	                                    	<span><fmt:formatDate value="${notice.startDate }"
														type="both" pattern="yyyy-MM-dd HH:mm:ss" /></span>
	                                    </div>
	                                </div>
	                            </div>
                        	</c:forEach>
						</div>
					</div>

				</div>
			</div>

		</div>
	</div>

	<div class="J_follow mt20">
		<div class="f_txt">
			<div class="t_center">
				为何选择<span>至盈网</span>？
			</div>
		</div>
		<div class="f_pic">
			<img src="${ctx }/static/images/follow.png">
		</div>

	</div>

	<div class="J_cooperation mt20">
        <div class="c_title"><span>合作伙伴</span></div>
        <div class="c_inner">
            <img src="${ctx }/static/tmp/cooperation.png" />
        </div>
    </div>

	<jsp:include page="common/help.jsp" />

	<jsp:include page="common/foot.jsp" />

</body>
</html>

