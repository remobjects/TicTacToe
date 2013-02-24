namespace TicTacToe;

interface

uses
  UIKit,
  GameKit;

type
  [IBObject]
  RootViewController = public class(UIViewController, IGKTurnBasedMatchmakerViewControllerDelegate, IGKTurnBasedEventHandlerDelegate, IBoardDelegate)
  private
    method nextLocalTurn(aCompletion: block ): Boolean;

    method yourTurn;
    method remoteTurn;
    method computerTurn;
    
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
    method handleTurnEventForMatch(match: GameKit.GKTurnBasedMatch) didBecomeActive(didBecomeActive: RemObjects.Oxygene.System.Boolean);
    method handleTurnEventForMatch(match: GameKit.GKTurnBasedMatch);
    method handleMatchEnded(match: GameKit.GKTurnBasedMatch);
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

  //61136: Nougat: HI badly imports NSObject<GKTurnBasedEventHandlerDelegate>
  //GKTurnBasedEventHandler.sharedTurnBasedEventHandler.delegate := self;
  
  fBoard := new Board withFrame(view.frame);
  fBoard.delegate := self;
  view.addSubview(fBoard);

  navigationController.navigationBar.topItem.rightBarButtonItem := new UIBarButtonItem withTitle('Games') 
                                                                                           style(UIBarButtonItemStyle.UIBarButtonItemStyleBordered) 
                                                                                           target(self) 
                                                                                           action(selector(newGame:)); 

  fBoard.acceptingTurn := true;
  fBoard.setStatus('hello');
  //var lAction := new UIActionSheet withTitle( ) ( ) delegate( ) ( ) cancelButtonTitle( ) ( ) destructiveButtonTitle( ) ( ) otherButtonTitles( ) ( ) 
 
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
  NSLog('match: %@', aMatch);

  //fBoard.clear(); // Internal NRE
  fBoard.clear(method begin
                 
                 fCurrentMatch := aMatch;
                 yourTurn();

               end);
end;

method RootViewController.turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) playerQuitForMatch(aMatch: GameKit.GKTurnBasedMatch);
begin
  NSLog('turnBasedMatchmakerViewController:playerQuitForMatch:');
end;
{$ENDREGION}

{$REGION IGKTurnBasedEventHandlerDelegate}
method RootViewController.handleInviteFromGameCenter(playersToInvite: NSArray);
begin
  NSLog('handleInviteFromGameCenter:');
end;

method RootViewController.handleTurnEventForMatch(match: GKTurnBasedMatch) didBecomeActive(didBecomeActive: Boolean);
begin
  NSLog('handleTurnEventForMatch:didBecomeActive:');
end;

method RootViewController.handleTurnEventForMatch(match: GKTurnBasedMatch);
begin
  NSLog('handleTurnEventForMatch:');
end;

method RootViewController.handleMatchEnded(match: GKTurnBasedMatch);
begin
  NSLog('handleMatchEnded:');
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

method RootViewController.yourTurn;
begin
  fBoard.acceptingTurn := true;
  fBoard.setStatus('your turn.');
end;

method RootViewController.remoteTurn;
begin
  fBoard.acceptingTurn := false;
  fBoard.setStatus('waiting');
  
  var i := fCurrentMatch.participants.indexOfObject(fCurrentMatch.currentParticipant);
  i := i+1;
  if i ≥ fCurrentMatch.participants.count then i := 0;

  var lMatchData := new NSData;

  fCurrentMatch.endTurnWithNextParticipant(fCurrentMatch.participants[i]) 
                matchData(lMatchData)
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
  if assigned(fBoard.markWinner) then begin
    
    fBoard.acceptingTurn := false;
    fBoard.setStatus('someone won');

  end
  else if fBoard.isFull then begin

    fBoard.acceptingTurn := false;
    fBoard.setStatus('game over');

  end
  else begin

    aCompletion();

  end;
end;

end.
