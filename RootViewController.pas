namespace TicTacToe;

interface

uses
  UIKit,
  GameKit;

type
  [IBObject]
  RootViewController = public class(UIViewController, IGKTurnBasedMatchmakerViewControllerDelegate, IBoardDelegate)
  private
    method nextLocalTurn;
    method nextLocalTurn(aCompletion: block ): Boolean;
    var fBoard: Board;
  public
    method init: id; override;

    method viewDidLoad; override;
    method didReceiveMemoryWarning; override;

    {$REGION IGKTurnBasedMatchmakerViewControllerDelegate}
    method turnBasedMatchmakerViewControllerWasCancelled(aViewController: GameKit.GKTurnBasedMatchmakerViewController);
    method turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFailWithError(aError: Foundation.NSError);
    method turnBasedMatchmakerViewController(aViewController: GameKit.GKTurnBasedMatchmakerViewController) didFindMatch(aMatch: GameKit.GKTurnBasedMatch);
    
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

  // Do any additional setup after loading the view.

  var request := new GKMatchRequest;
  request.minPlayers := 2;
  request.maxPlayers := 2;
 
  var mmvc := new GKTurnBasedMatchmakerViewController WithMatchRequest(request);
  mmvc.turnBasedMatchmakerDelegate := self;

  fBoard := new Board withFrame(view.frame);
  fBoard.delegate := self;
  view.addSubview(fBoard);

  //var lAction := new UIActionSheet withTitle( ) ( ) delegate( ) ( ) cancelButtonTitle( ) ( ) destructiveButtonTitle( ) ( ) otherButtonTitles( ) ( ) 
 
  //presentViewController(mmvc) animated(YES) completion(nil);
end;

method RootViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;

  // Dispose of any resources that can be recreated.
end;

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
end;

method RootViewController.board(aBoard: Board) playerWillSelectGridIndex(aGridIndex: GridIndex): Boolean;
begin
  result := true;
end;

method RootViewController.board(aBoard: Board) playerDidSelectGridIndex(aGridIndex: GridIndex);
begin
  nextLocalTurn(method begin
  
      fBoard.acceptingTurn := false;
      fBoard.setStatus('thinkng...');
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), method begin
          
          NSThread.sleepForTimeInterval(0.75);
          dispatch_async(@_dispatch_main_q, method begin
              fBoard.makeComputerMove('O');
              
              nextLocalTurn(method begin

                  fBoard.acceptingTurn := true;
                  fBoard.setStatus('your turn.');

                end);

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

method RootViewController.nextLocalTurn;
begin

end;

end.
