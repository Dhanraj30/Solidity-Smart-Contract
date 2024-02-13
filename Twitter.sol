// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//1 define  a tweet struct with auther, content, timestamp , likes
//2 add struct to array
//3 test tweets
//create constructor fun to set owner of contract
//create modifier called onlyowner
//add fun changelengthtweet
//use onlyowner change tweetlength
//add tweet likes
// add id to tweet struct to make every tweet unique
//set the id to be  Tweet[] length
//add events

contract Twitter {
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    
    address public owner;
    mapping(address => Tweet[]) public tweets;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp );
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    } 
    
    
    uint16 public MAX_TWEET_LENGTH = 280;

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is to long");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);

        emit TweetCreated( newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet( address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweets does not exist");
        tweets[author][id].likes++;
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes--;
        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);

    }

    function getTweet( uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweet(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}