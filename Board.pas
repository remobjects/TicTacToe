namespace TicTacToe;

interface

uses
  UIKit;

type
  [IBObject]
  Board = public class(UIControl)
  private
    fGridOffset: CGPoint;
    fStatusLabel: UILabel;
    
    fTentativeView: UIImageView;
    fTentativeGridIndex: GridIndex;
    fTentativeOk: Boolean;

    fTurnCount: Int32;
    fGridImages: array[0..2, 0..2] of UIImageView;
    fGridInfo: array[0..2, 0..2] of NSString;

    const 
      X1 = 92;
      X2 = 217;
      Y1 = 93;
      Y2 = 200;

    method gridIndexForPoint(aPoint: CGPoint): GridIndex;
    method drawingOffsetForGridIndex(aGridIndex: GridIndex): CGPoint;

    method markGrid(aX: Int32; aY: Int32; aPlayer: String; aImageview: UIImageView);
    method playerimageForTurn(aPlayer: String): UIImageView;
  public
    method initWithFrame(aFrame: CGRect): id; override;

    property &delegate: weak IBoardDelegate;
    property player: String := 'X'; 
    property acceptingTurn: Boolean;

    //property GridInfo: array[0..2, 0..2] of NSString read fGridInfo; // internal error

    method markGrid(aX: Int32; aY: Int32; aPlayer: String); 
    method makeComputerMove(aPlayer: String);
    method isFull: Boolean; 
    method markWinner: String; 

    method setStatus(aStatus: String);

    method beginTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent): Boolean; override;
    method continueTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent): Boolean; override;
    method endTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent); override;
  end;

  IBoardDelegate = public interface(INSObject)
    method board(aBoard: Board) playerWillSelectGridIndex(aGridIndex: GridIndex): Boolean;
    method board(aBoard: Board) playerDidSelectGridIndex(aGridIndex: GridIndex);
  end;

  GridIndex = public record
  public
    X, Y: Integer;
  end;

implementation

method Board.initWithFrame(aFrame: CGRect): id;
begin
  self := inherited initWithFrame(aFrame);
  if assigned(self) then begin

    addSubview(new UIImageView withImage(UIImage.imageNamed('Paper')));

    var lGridImage := UIImage.imageNamed('Grid');

    var fGrid := new UIImageView withImage(lGridImage);
    fGrid.frame := CGRectMake( (frame.size.width-lGridImage.size.width)/2, 
                               (frame.size.width-lGridImage.size.width)*2,
                               lGridImage.size.width,
                               lGridImage.size.height);
    fGridOffset := fGrid.frame.origin;
    NSLog('%f, %f, %f', frame.size.height, lGridImage.size.height, (frame.size.height-lGridImage.size.width)/2);
    addSubview(fGrid);

    var lFont := UIFont.fontWithName('Bradley Hand') size(48);

    var f := frame;
    f.origin.y := fGrid.frame.origin.y + fGrid.frame.size.height + 10; // 30 on 4"?
    f.size.height := 'Xy'.sizeWithFont(lFont).height;

    fStatusLabel := new UILabel withFrame(f);
    fStatusLabel.opaque := false;
    fStatusLabel.backgroundColor := UIColor.colorWithRed(0) green(0) blue(0) alpha(0); 
    fStatusLabel.font := lFont; 
    fStatusLabel.textAlignment := NSTextAlignment.NSTextAlignmentCenter;
    addSubview(fStatusLabel);


    fStatusLabel.text := 'hello';

  end;
  result := self;
end;

method Board.markGrid(aX: Int32; aY: Int32; aPlayer: String); 
begin
  markGrid(aX, aY, aPlayer, nil);
end;

method Board.playerimageForTurn(aPlayer: String): UIImageView;
begin
  NSLOg('turn %d', fTurnCount/2+1);
  //var lTurnSuffix := (fTurnCount/2+1).stringValue;
  var lTurnSuffix := NSNUmber.numberWithInt(fTurnCount/2+1).stringValue;
  NSLOg('turn %@', lTurnSuffix);

  aPlayer := aPlayer+lTurnSuffix;
  result := new UIImageView withImage(UIImage.imageNamed(aPlayer));
end;

method Board.markGrid(aX: Int32; aY: Int32; aPlayer: String; aImageview: UIImageView); 
require
 { 0 ≤ aX < 2;
  0 ≤ aY < 2;
  fGridInfo[aX, aY] = nil;
  aPlayer in ['X','O'];} // Type Mismatch 0/0
begin
  //var lTrnSuffix := '1';  // crash, log, with ''
  inc(fTurnCount);
  NSLOg('turn %d', fTurnCount/2+1);
  //var lTurnSuffix := (fTurnCount/2+1).stringValue;
  var lTurnSuffix := NSNUmber.numberWithInt(fTurnCount/2+1).stringValue;
  NSLOg('turn %@', lTurnSuffix);

  //aPlayer := aPlayer.stringByAppendingString(lTurnSuffix);
  fGridInfo[aX, aY] := aPlayer;

  if not assigned(aImageview) then begin
  
    var lNewView := playerimageForTurn(aPlayer);
    lNewView.alpha := 0;

    var f: CGRect;
  
    var g: GridIndex; g.X := aX; g.Y := aY;
    f.origin := drawingOffsetForGridIndex(g);
    f.size := lNewView.image.size;
    lNewView.frame := f;
    addSubview(lNewView);
    fGridImages[aX, aY] := lNewView;

    UIView.animateWithDuration(0.5) 
            animations(method begin
                lNewView.alpha := 1;
              end);
  end
  else begin
    fGridImages[aX, aY] := aImageview;

    {UIView.animateWithDuration(0.5) 
            animations(method begin
                aImageview.alpha := 1;
              end);}
  end;
end;

method Board.beginTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent): Boolean;
begin
  if not acceptingTurn then exit false;
  
  continueTrackingWithTouch(aTouch) withEvent(aEvent);
  result := true;
end;

method Board.continueTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent): Boolean;
begin

  var lFirst: Boolean;

  if not assigned(fTentativeView) then begin
    fTentativeView := playerimageForTurn(player);
    fTentativeView.alpha := 0;
    addSubview(fTentativeView);
    lFirst := true;
  end;

  var lTouchLocation := aTouch.locationInView(self);
  fTentativeGridIndex := gridIndexForPoint(lTouchLocation);
  fTentativeOk := fGridInfo[fTentativeGridIndex.X, fTentativeGridIndex.Y] = nil;

  var f: CGRect;
  f.origin := drawingOffsetForGridIndex(fTentativeGridIndex);
  f.size := fTentativeView.image.size;

  if lFirst then
    fTentativeView.frame := f;

  UIView.animateWithDuration(0.1) 
         animations(method begin
                          
             fTentativeView.frame := f;

             if fTentativeOk then
               fTentativeView.alpha := 0.8
            else
               fTentativeView.alpha := 0.0; 
                          
           end);
    
  result := true;
end;

method Board.endTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent);
begin
  NSLog('endTrackingWithTouch');
  if assigned(fTentativeView) then begin

    if fTentativeOk then begin

      markGrid(fTentativeGridIndex.X, fTentativeGridIndex.Y, player, fTentativeView);
      if assigned(&delegate) then
        &delegate.board(self) playerDidSelectGridIndex(fTentativeGridIndex);

    end 
    else begin

      var lTempView := fTentativeView;
      UIView.animateWithDuration(0.1) 
             animations(method begin
                 fTentativeView.alpha := 0;
               end) 
             completion(method begin
                 lTempView.removeFromSuperview();
               end);

    end;
    fTentativeView := nil;

  end;
end;

method Board.gridIndexForPoint(aPoint: CGPoint): GridIndex;
begin
  aPoint.x := aPoint.x-fGridOffset.x;
  aPoint.y := aPoint.y-fGridOffset.y;
  // := new GridIndex;
  result.X := if aPoint.x < X1 then 0 else if aPoint.x < X2 then 1 else 2;
  result.Y := if aPoint.y < Y1 then 0 else if aPoint.y < Y2 then 1 else 2;
end;

method Board.drawingOffsetForGridIndex(aGridIndex: GridIndex): CGPoint;
begin
  {result.x := case aGridIndex.X of
                0: 10;
                1: X1+10;
                2: X2+10;
              end;
  result.y := case aGridIndex.Y of
                0: 10;
                1: Y1+10;
                2: Y2+10;
              end;}
  result := CGPointMake(10+110*aGridIndex.X+fGridOffset.x, 10+100*aGridIndex.Y+fGridOffset.y);

end;

method Board.makeComputerMove(aPlayer: String);
begin
  for x: Int32 := 0 to 2 do 
    for y: Int32 := 0 to 2 do
      if not assigned(fGridInfo[x,y]) then begin
        markGrid(x, y, aPlayer);
        exit;
      end;
end;

method Board.isFull: Boolean;
begin
  for x: Int32 := 0 to 2 do 
    for y: Int32 := 0 to 2 do
      if not assigned(fGridInfo[x,y]) then begin
        exit false;
      end;
  result := true;
end;

method Board.markWinner: String;
begin
  result := nil;
end;

method Board.setStatus(aStatus: String);
begin
  if length(fStatusLabel.text) > 0 then begin

    UIView.animateWithDuration(0.1) 
           animations(method begin
               fStatusLabel.alpha := 0;
             end) 
           completion(method begin
               fStatusLabel.text := aStatus;
               if length(aStatus) > 0 then begin

                 UIView.animateWithDuration(0.3) 
                        animations(method begin
                            fStatusLabel.alpha := 1.0;
                          end); 

               end;
             end);

  end
  else begin

    fStatusLabel.text := aStatus;
    if length(aStatus) > 0 then begin

      UIView.animateWithDuration(0.3) 
            animations(method begin
                fStatusLabel.alpha := 1.0;
              end);

    end;
  end;
end;

end.
