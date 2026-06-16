import Foundation
import StopPlay

/// Decoded game events emitted by ConnectionManager after receiving a GameAction.
/// View models subscribe to these via a single callback instead of ConnectionManager
/// holding direct weak references.
enum GameEvent {
    case didReceiveAnswer(answer: Response, from: String)
    case didReceiveVote(category: String, voterName: String, selectedIndexes: Set<Int>)
    case didReceiveSetAnswers(answers: [String: [Response]])
    case didReceiveChangeStatus(status: ConnectionStatus)
    case didReceiveChangeCategory
    case didReceiveSetCategories(categories: [String])
}
