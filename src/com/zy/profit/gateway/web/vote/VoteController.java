package com.zy.profit.gateway.web.vote;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zy.common.entity.ResultDto;
import com.zy.member.entity.Member;
import com.zy.profit.gateway.util.HttpUtils;
import com.zy.util.AddressUtils;
import com.zy.vote.entity.VoteMemberLog;
import com.zy.vote.entity.VotePostPraise;
import com.zy.vote.entity.VotePostReport;
import com.zy.vote.entity.VoteTopic;
import com.zy.vote.entity.VoteTopicOption;
import com.zy.vote.entity.VoteTopicPost;
import com.zy.vote.entity.VoteTopicPostReplay;
import com.zy.vote.service.VoteMemberLogService;
import com.zy.vote.service.VotePostPraiseService;
import com.zy.vote.service.VotePostReportService;
import com.zy.vote.service.VoteTopicOptionService;
import com.zy.vote.service.VoteTopicPostReplayService;
import com.zy.vote.service.VoteTopicPostService;
import com.zy.vote.service.VoteTopicService;

/**
 * 网站投票、跟帖
 * @author pingan
 * @since  2015-09-23
 */

@Controller
@RequestMapping("/vote")
public class VoteController {
	
	public static final String RESULT_CODE_VOTE_ERROR = "401";//用户对投票重复投票
	public static final String RESULT_CODE_PRAISE_ERROR = "402";//用户对帖子重复点赞
	public static final String RESULT_CODE_REPORT_ERROR = "403";//用户对帖子重复举报

	@Autowired
	private VoteTopicService voteTopicService;
	@Autowired
	private VoteTopicOptionService voteTopicOptionService;
	@Autowired
	private VoteTopicPostService voteTopicPostService;
	@Autowired
	private VoteTopicPostReplayService voteTopicPostReplayService;
	@Autowired
	private VoteMemberLogService voteMemberLogService;
	@Autowired
	private VotePostPraiseService votePostPraiseService;
	@Autowired
	private VotePostReportService votePostReportService;
	
	
	@RequestMapping("/index")
	public String index(Model model){
		
		List<VoteTopic> currentTopics = voteTopicService.getTopicBySchedule(VoteTopic.SCHEDULE_CURRENT);
		List<VoteTopic> nextTopics = voteTopicService.getTopicBySchedule(VoteTopic.SCHEDULE_NEXT);
		
		if(CollectionUtils.isNotEmpty(currentTopics))
			model.addAttribute("currentTopic", currentTopics.get(0));
		if(CollectionUtils.isNotEmpty(nextTopics))
			model.addAttribute("nextTopic", nextTopics.get(0));
		
		model.addAttribute("topics", voteTopicService.getTopicBySchedule(VoteTopic.SCHEDULE_DEFAULT));
		
		return "vote/voteIndex";
	}
	
	@RequestMapping("/doVote")
	@ResponseBody
	public ResultDto<VoteTopic> doVote(VoteTopicOption dto, HttpServletRequest request){
		ResultDto<VoteTopic> result = new ResultDto<VoteTopic>();
		try {
			Member member = HttpUtils.getMember(request);
			int logNumb = voteMemberLogService.findMemberTopicLog(member.getId(), dto.getVoteTopic().getId());
			if(logNumb>0){
				result.setSuccess(false);
				result.setCode(RESULT_CODE_VOTE_ERROR);
				return result;
			}
			
			VoteMemberLog voteLog = new VoteMemberLog();
			voteLog.setVoteTopic(dto.getVoteTopic());
			voteLog.setVoteTopicOption(dto);
			voteLog.setMember(member);
			voteLog.setIpAddress(AddressUtils.getIp(request));
			voteMemberLogService.save(voteLog);
			
			VoteTopicOption optionEntity = voteTopicOptionService.get(dto.getId());
			optionEntity.setVoteCount(optionEntity.getVoteCount()+1);
			voteTopicOptionService.update(optionEntity);
			
			VoteTopic topicEntity = voteTopicService.get(dto.getVoteTopic().getId());
			topicEntity.setVoteCount(topicEntity.getVoteCount()+1);
			voteTopicService.update(topicEntity);
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doPraise")
	@ResponseBody
	public ResultDto<VoteTopicPost> praise(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			Member member = HttpUtils.getMember(request);
			int memberPostNumb = votePostPraiseService.findMemberPraise(member.getId(), dto.getId());
			if(memberPostNumb>0){//该帖子用户已经点赞
				result.setSuccess(false);
				result.setCode(RESULT_CODE_PRAISE_ERROR);
				return result;
			}
			
			VotePostPraise praise = new VotePostPraise();
			praise.setVoteTopicPost(dto);
			praise.setMember(member);
			praise.setIpAddress(AddressUtils.getIp(request));
			votePostPraiseService.save(praise);
			
			VoteTopicPost postEntity = voteTopicPostService.get(dto.getId());
			postEntity.setPraiseCount(postEntity.getPraiseCount()+1);
			voteTopicPostService.update(postEntity);
			
			result.setMessage(postEntity.getPraiseCount()+"");
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReport")
	@ResponseBody
	public ResultDto<VoteTopicPost> report(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			Member member = HttpUtils.getMember(request);
			int memberPostNumb = votePostPraiseService.findMemberPraise(member.getId(), dto.getId());
			if(memberPostNumb>0){//该帖子用户已经举报
				result.setSuccess(false);
				result.setCode(RESULT_CODE_REPORT_ERROR);
				return result;
			}
			
			VotePostReport report = new VotePostReport();
			report.setVoteTopicPost(dto);
			report.setMember(member);
			report.setIpAddress(AddressUtils.getIp(request));
			votePostReportService.save(report);
			
			VoteTopicPost postEntity = voteTopicPostService.get(dto.getId());
			postEntity.setReportCount(postEntity.getReportCount()+1);
			voteTopicPostService.update(postEntity);
			
			result.setMessage(postEntity.getReportCount()+"");
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doPost")
	@ResponseBody
	public ResultDto<VoteTopicPost> post(VoteTopicPost dto, HttpServletRequest request){
		ResultDto<VoteTopicPost> result = new ResultDto<VoteTopicPost>();
		try {
			dto.setPublisher(HttpUtils.getMember(request));
			dto.setPraiseCount(0);
			dto.setReportCount(0);
			dto.setIpAddress(AddressUtils.getIp(request));
			voteTopicPostService.save(dto);
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/doReplay")
	@ResponseBody
	public ResultDto<VoteTopicPostReplay> raplay(VoteTopicPostReplay dto, HttpServletRequest request){
		ResultDto<VoteTopicPostReplay> result = new ResultDto<VoteTopicPostReplay>();
		try {
			dto.setReplayer(HttpUtils.getMember(request));
			dto.setIpAddress(AddressUtils.getIp(request));
			voteTopicPostReplayService.save(dto);
		} catch (Exception e) {
			e.printStackTrace();
			result.setSuccess(false);
		}
		return result;
	}
	
	@RequestMapping("/replayDialog")
	public String replayDialog(){
		
		return "vote/replayDialog";
	}
	
}
