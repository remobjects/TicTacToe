namespace TicTacToe;

interface

uses
  UIKit,
  GameKit;

type
  [IBObject]
  RootViewController = public class(UIViewController, IGKTurnBasedMatchmakerViewControllerDelegate, IGKTurnBasedEventHandlerDelegate, IBoardDelegate)
  private
    method dictionaryFromData(aData: NSData): NSDictionary;
    method dataFromDictionary(aDictioanry: NSDictionary): NSData;
    method getMatchDataFromBoard: NSData;

    method nextLocalTurn(aCompletion: block ): Boolean;
    method nextParticipantForMatch(aMatch: GKTurnBasedMatch): GKTurnBasedParticipant;
    method remoteParticipantForMatch(aMatch: GKTurnBasedMatch): GKTurnBasedParticipant;

    method yourTurn;
    method remoteTurn;
    method computerTurn;
    method loadCurrentMatch(aResumePlay: Boolean := true);


    [IBAction] method newGame(aSender: id);
    var fBoard: Board;
    var fCurrentMatch: GKTurnBasedMatch;
  public
    method init: id; override;

    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;

    {$REGION IGKTurnBasedMatchmakerViewControllerDelegate}
    method turnBasedMatchmakerViewControllerWasCancelled(aViewController: GameKit.GKTurnBasedMatchmakerViewController);
    method turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFailWithError(aError: Foundation.NSError);
    method turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFindMatch(aMatch: GameKit.GKTurnBasedMatch);
    method turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) playerQuitForMatch(aMatch: GameKit.GKTurnBasedMatch);
    {$ENDREGION}
    
    {$REGION IGKTurnBasedEventHandlerDelegate}
    method handleInviteFromGameCenter(playersToInvite: Foundation.NSArray);
    method handleTurnEventForMatch(aMatch: GameKit.GKTurnBasedMatch) didBecomeActive(didBecomeActive: RemObjects.Oxygene.System.Boolean);
    method handleTurnEventForMatch(aMatch: GameKit.GKTurnBasedMatch);
    method handleMatchEnded(aMatch: GameKit.GKTurnBasedMatch);
    {$ENDREGION}

    {$REGION IBoardDelegate}
    method board(aBoard: Board) playerWillSelectGridIndex(aGridIndex: GridIndex): Boolean;
    method board(aBoard: Board) playerDidSelectGridIndex(aGridIndex: GridIndex);
    {$ENDREGION}
  end;

implementation

method RootViewController.init: id;
begin
  self := inherited initWithNibName('RootViewController') bundle(nil);
  if assigned(self) then begin

    title := 'Tic Tac Toe';

    // Custom initialization

  end;
  result := self;
end;

method RootViewController.viewDidLoad;
begin
  inherited viewDidLoad;

  GKTurnBasedEventHandler.sharedTurnBasedEventHandler.delegate := self;
  
  fBoard := new Board withFrame(view.frame);
  fBoard.delegate := self;
  view.addSubview(fBoard);

  navigationController.navigationBar.topItem.rightBarButtonItem := new UIBarButtonItem withTitle('Games') 
                                                                                           style(UIBarButtonItemStyle.UIBarButtonItemStyleBordered) 
                                                                                           target(self) 
                                                                                           action(selector(newGame:)); 

  fBoard.acceptingTurn := true;
  fBoard.setStatus('hello');
 
end;

method RootViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;

  // Dispose of any resources that can be recreated.
end;

method RootViewController.newGame(aSender: id);
begin
  var request := new GKMatchRequest;
  request.minPlayers := 2;
  request.maxPlayers := 2;
 
  var mmvc := new GKTurnBasedMatchmakerViewController WithMatchRequest(request);
  mmvc.turnBasedMatchmakerDelegate := self;
  mmvc.showExistingMatches := true;
  presentViewController(mmvc) animated(true) completion(nil);

end;

{$REGION IGKTurnBasedMatchmakerViewControllerDelegate}
method RootViewController.turnBasedMatchmakerViewControllerWasCancelled(aViewController: GameKit.GKTurnBasedMatchmakerViewController);
begin
  NSLog('turnBasedMatchmakerViewControllerWasCancelled:');
  aViewController.dismissViewControllerAnimated(true) completion(nil);
end;

method RootViewController.turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFailWithError(aError: NSError);
begin
  NSLog('turnBasedMatchmakerViewController:didFailWithError: %@', aError);
  aViewController.dismissViewControllerAnimated(true) completion(nil);
end;

method RootViewController.turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFindMatch(aMatch: GameKit.GKTurnBasedMatch);
begin
  NSLog('turnBasedMatchmakerViewController:didFindMatch:');
  aViewController.dismissViewControllerAnimated(true) completion(nil);

  //fBoard.clear(); // Internal NRE
  fBoard.clear(method begin
                 
                 fCurrentMatch := aMatch;
                 loadCurrentMatch();
               end, true);
end;

method RootViewController.turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) playerQuitForMatch(aMatch: GameKit.GKTurnBasedMatch);
begin
  NSLog('turnBasedMatchmakerViewController:playerQuitForMatch:');

  if aMatch.currentParticipant.playerID =  GKLocalPlayer.localPlayer.playerID then begin
    aMatch.participantQuitInTurnWithOutcome(GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeQuit) 
           nextParticipant(nextParticipantForMatch(aMatch)) 
           matchData(nil) 
           completionHandler(method begin
        NSLog('participantQuitInTurnWithOutcome completion');
      end); 
  end
  else begin
    aMatch.participantQuitOutOfTurnWithOutcome(GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeQuit) withCompletionHandler(method begin
        NSLog('participantQuitOutOfTurnWithOutcome completion');
      end) 
  end;
end;
{$ENDREGION}

{$REGION IGKTurnBasedEventHandlerDelegate}
method RootViewController.handleInviteFromGameCenter(playersToInvite: NSArray);
begin
  NSLog('handleInviteFromGameCenter:');
end;

method RootViewController.handleTurnEventForMatch(aMatch: GKTurnBasedMatch) didBecomeActive(didBecomeActive: Boolean);
begin
  NSLog('handleTurnEventForMatch:%@ didBecomeActive:%d (current match is %@)', aMatch, didBecomeActive, fCurrentMatch);
  fBoard.clear(method begin
                 fCurrentMatch := aMatch;
                 loadCurrentMatch();
               end, fCurrentMatch:matchID ≠ aMatch:matchID);
end;

method RootViewController.handleTurnEventForMatch(aMatch: GKTurnBasedMatch);
begin
  NSLog('handleTurnEventForMatch:');
end;

method RootViewController.handleMatchEnded(aMatch: GKTurnBasedMatch);
begin
  NSLog('handleMatchEnded:%@ (current match is %@)', aMatch, fCurrentMatch);
  fBoard.clear(method begin
                 fCurrentMatch := aMatch;
                 loadCurrentMatch(false);

                 var lStatus := 'game over';

                 for each p: GKTurnBasedParticipant in fCurrentMatch.participants do begin
                   if p.playerID = GKLocalPlayer.localPlayer.playerID then begin
                     if p.matchOutcome = GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeWon then
                       lStatus := 'you won'
                     else if p.matchOutcome = GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeLost then
                       lStatus := 'you lost'
                     else
                       lStatus := 'tied';
                   end;
                 end;

                 fBoard.setStatus(lStatus); 
               end, fCurrentMatch:matchID ≠ aMatch:matchID);
end;
{$ENDREGION}

{$REGION IBoardDelegate}
method RootViewController.board(aBoard: Board) playerWillSelectGridIndex(aGridIndex: GridIndex): Boolean;
begin
  result := true;
end;

method RootViewController.board(aBoard: Board) playerDidSelectGridIndex(aGridIndex: GridIndex);
begin
  nextLocalTurn(method begin

      fBoard.acceptingTurn := false;
      if assigned(fCurrentMatch) then 
        remoteTurn()
      else
        computerTurn();
  
  end);
end;
{$ENDREGION}

method RootViewController.dictionaryFromData(aData: NSData): NSDictionary;
begin
  if not assigned(aData) or (aData.length = 0) then exit new NSDictionary;
  var unarchiver := new NSKeyedUnarchiver forReadingWithData(aData);
  result := unarchiver.decodeObjectForKey('board');
  unarchiver.finishDecoding();
end;

method RootViewController.dataFromDictionary(aDictioanry: NSDictionary): NSData;
begin
  result := new NSMutableData;
  var archiver := new NSKeyedArchiver forWritingWithMutableData(result as NSMutableData);
  archiver.encodeObject(aDictioanry) forKey('board');
  archiver.finishEncoding();
end;

method RootViewController.loadCurrentMatch(aResumePlay: Boolean := true);
begin
  var lDictionary := dictionaryFromData(fCurrentMatch.matchData);
  fBoard.loadFromNSDictionary(lDictionary, GKLocalPlayer.localPlayer.playerID, remoteParticipantForMatch(fCurrentMatch):playerID); 

  fBoard.acceptingTurn := false;
  if assigned(fCurrentMatch.currentParticipant) then begin
    if fCurrentMatch.currentParticipant.playerID = GKLocalPlayer.localPlayer.playerID then begin
      if aResumePlay then yourTurn();
    end
    else begin
      if  aResumePlay then begin
        if length(fCurrentMatch.currentParticipant.playerID) > 0 then begin
          fBoard.setStatus(fCurrentMatch.currentParticipant.playerID);
          GKPlayer.loadPlayersForIdentifiers(NSArray.arrayWithObject(fCurrentMatch.currentParticipant.playerID)) 
                   withCompletionHandler(method(aPlayers: NSArray; aError: NSError) begin
                       NSLog('loadPlayersForIdentifiers:completion: completion(%@, %@)', aPlayers, aError);
                       if aPlayers.count > 0 then
                         dispatch_async(@_dispatch_main_q, -> fBoard.setStatus(aPlayers[0].alias));
                        NSLog('alias: %@', aPlayers[0].alias);
                     end);
        end;
      end
      else begin
        fBoard.setStatus('waiting for player');
      end;
    end;
  end
  else begin
    if aResumePlay then 
      fBoard.setStatus('game over'); // shouldn't really happen
  end;
end;

method RootViewController.yourTurn;
begin
  fBoard.acceptingTurn := true;
  fBoard.setStatus('your turn.');
end;


method RootViewController.remoteParticipantForMatch(aMatch: GKTurnBasedMatch): GKTurnBasedParticipant;
begin
  if aMatch.participants[0]:playerID.isEqualToString(GKLocalPlayer.localPlayer.playerID) then
    result := aMatch.participants[1]
  else
    result := aMatch.participants[0];
end;

method RootViewController.nextParticipantForMatch(aMatch: GKTurnBasedMatch): GKTurnBasedParticipant;
begin
  var i := aMatch.participants.indexOfObject(aMatch.currentParticipant);
  i := i+1;
  if i ≥ aMatch.participants.count then i := 0;
  result := aMatch.participants[i]
end;

method RootViewController.getMatchDataFromBoard: NSData;
begin
  var lDictionary := new NSMutableDictionary();
  fBoard.saveToNSDictionary(lDictionary, GKLocalPlayer.localPlayer.playerID, remoteParticipantForMatch(fCurrentMatch):playerID); 
  result := dataFromDictionary(lDictionary) ;
end;

method RootViewController.remoteTurn;
begin
  fBoard.acceptingTurn := false;
  fBoard.setStatus('waiting');

  fCurrentMatch.endTurnWithNextParticipant(nextParticipantForMatch(fCurrentMatch)) 
                matchData(getMatchDataFromBoard)
                completionHandler(method (aError: NSError) begin
                    NSLog('endTurnWithNextParticipant completion');
                    if assigned(aError) then
                      NSLog('error: %@', aError);
                  end);
end;

method RootViewController.computerTurn;
begin
  fBoard.acceptingTurn := false;
  fBoard.setStatus('thinkng...');
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), method begin
          
      NSThread.sleepForTimeInterval(0.75);
      dispatch_async(@_dispatch_main_q, method begin
          fBoard.makeComputerMove('O');
              
          nextLocalTurn(method begin

              yourTurn();

            end);

        end);
    end);
end;

method RootViewController.nextLocalTurn(aCompletion: block): Boolean;
begin
  var lWinner := fBoard.markWinner;
  if assigned(lWinner) then begin
    
    fBoard.acceptingTurn := false;
    if lWinner = "X" then
      fBoard.setStatus('you won')
    else
      fBoard.setStatus('you lost'); // we can only get here in single player mode

    if assigned(fCurrentMatch) then begin
      
      // only the player making the turn can win
      for each p: GKTurnBasedParticipant in fCurrentMatch.participants do
        if p.playerID = GKLocalPlayer.localPlayer.playerID then
          p.matchOutcome := GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeWon
        else
          p.matchOutcome := GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeLost;
      //fCurrentMatch.message := 'Game was tied.';
      fCurrentMatch.endMatchInTurnWithMatchData(getMatchDataFromBoard) completionHandler(method (aError: NSError) begin

        end);
    end;

  end
  else if fBoard.isFull then begin

    fBoard.acceptingTurn := false;
    fBoard.setStatus('game over');

    if assigned(fCurrentMatch) then begin
      for each p: GKTurnBasedParticipant in fCurrentMatch.participants do 
        p.matchOutcome := GKTurnBasedMatchOutcome.GKTurnBasedMatchOutcomeTied;
        //fCurrentMatch.message := 'Game was tied.';
        fCurrentMatch.endMatchInTurnWithMatchData(getMatchDataFromBoard) completionHandler(method (aError: NSError) begin

          end);
    end;

  end
  else begin

    aCompletion();

  end;
end;

end.
