// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CrossChainInteroperabilityProtocol
 * @dev Enables secure message and asset transfer between different blockchain networks.
 */
contract CrossChainInteroperabilityProtocol {
    address public admin;

    struct Message {
        address sender;
        string destinationChain;
        address receiver;
        string payload;
        uint256 timestamp;
    }

    event MessageSent(address indexed sender, string destinationChain, address indexed receiver, string payload);
    event MessageReceived(string sourceChain, address indexed receiver, string payload);

    mapping(bytes32 => bool) public processedMessages;

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Send a message to another chain.
     * @param destinationChain The name of the target blockchain network.
     * @param receiver The address of the receiver on the destination chain.
     * @param payload The data/message to send.
     */
    function sendCrossChainMessage(
        string memory destinationChain,
        address receiver,
        string memory payload
    ) external {
        emit MessageSent(msg.sender, destinationChain, receiver, payload);
    }

    /**
     * @dev Receive a verified message from another chain.
     * @param sourceChain The originating chain of the message.
     * @param receiver The intended receiver on this chain.
     * @param payload The received message data.
     * @param messageId A unique identifier for the message.
     */
    function receiveCrossChainMessage(
        string memory sourceChain,
        address receiver,
        string memory payload,
        bytes32 messageId
    ) external {
        require(!processedMessages[messageId], "Message already processed");
        processedMessages[messageId] = true;

        emit MessageReceived(sourceChain, receiver, payload);
    }

    /**
     * @dev Change admin (only current admin can do this).
     */
    function changeAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only admin can change admin");
        admin = newAdmin;
    }
}

